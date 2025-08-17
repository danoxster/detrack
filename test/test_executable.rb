require 'minitest/autorun'
require 'open3'
require 'json'

class TestClientSearchExecutable < Minitest::Test

  def setup
    @executable = File.expand_path('../bin/client_search', __dir__)
    @client_json_path = File.join(__dir__, 'fixtures', 'clients.json')
    @nodup_json_path = File.join(__dir__, 'fixtures', 'no_duplicate_emails.json')
    @invalid_json_path = File.join(__dir__, 'fixtures', 'invalid_clients.json')
    @not_list_json_path = File.join(__dir__, 'fixtures', 'not_a_list.json')
  end

  def test_executable_exists
    assert File.exist?(@executable), 'Executable should exist at #{@executable}'
    assert File.executable?(@executable), 'File should be executable'
  end

  # Help option tests
  def test_help_option_long
    stdout, _, status = execute_client_search ['--help']
    assert status.success?, 'Should exit successfully with --help'
    assert_includes stdout, 'Usage:', 'Should show usage message'
    assert_includes stdout, '--name', 'Should show name option'
    assert_includes stdout, '--duplicates', 'Should show duplicates option'
  end

  def test_help_option_short
    stdout, _, status = execute_client_search ['-h']

    assert status.success?, 'Should exit successfully with -h'
    assert_includes stdout, 'Usage:', 'Should show usage message'
  end

  # Error handling tests
  def test_no_options_provided
    stdout, _, status = execute_client_search

    assert !status.success?, "Should exit with error when no options provided"
    assert_includes stdout, "Error: Must specify either --name or --duplicates", "Should show specific error"
    assert_includes stdout, "Usage:", "Should show usage"
  end

  def test_name_search_without_search_term
    _, _, status = execute_client_search ['--name']

    assert !status.success?, "Should exit with error when --name has no argument"
  end

  def test_name_search_with_empty_search_term
    stdout, _, status = execute_client_search ['--name', '', @client_json_path]

    assert !status.success?, 'Should exit with error with empty search term'
    assert_includes stdout, 'Error: Search term is required', 'Should show search term error'
  end

  def test_nonexistent_file_error
    stdout, _, status = execute_client_search ['--name', 'jane', '/nonexistent/file.json']

    assert !status.success?, 'Should exit with error with nonexistent file'
    assert_includes stdout, "Error: File '/nonexistent/file.json' does not exist", 'Should show file error'
  end

  # Name search tests
  def test_name_search_with_file_long_option
    stdout, _, status = execute_client_search ['--name', 'jane', @client_json_path]

    assert status.success?, 'Should exit successfully'
    assert_includes stdout, "Name search results for 'jane':", 'Should show search header'
    assert_includes stdout, 'Jane Smith', 'Should find Jane Smith'
    assert_includes stdout, 'Another Jane Smith', 'Should find Another Jane Smith'
    refute_includes stdout, 'John', 'Should not include John names'
  end

  def test_name_search_with_file_short_option
    stdout, _, status = execute_client_search ['-n', 'john', @client_json_path]

    assert status.success?, 'Should exit successfully with -n'
    assert_includes stdout, "Name search results for 'john':", 'Should show search header'
    assert_includes stdout, 'John Doe', 'Should find John Doe'
    assert_includes stdout, 'Alex Johnson', 'Should find Alex Johnson'
    refute_includes stdout, 'Jane', 'Should not include Jane names'
  end

  def test_name_search_no_results
    stdout, _, status = execute_client_search ['--name', 'name that does not exist', @client_json_path]

    assert status.success?, 'Should exit successfully even with no results'
    assert_includes stdout, "Name search results for 'name that does not exist':", 'Should show search header'
    assert_includes stdout, "No matches found for 'name that does not exist'", 'Should show no matches message'
  end

  def test_name_search_with_stdin
    json_data = File.read(@client_json_path)

    stdout, _, status = execute_client_search ['--name', 'jane', stdin_data: json_data]

    assert status.success?, 'Should process stdin input successfully'
    assert_includes stdout, "Name search results for 'jane':", 'Should show search header'
    assert_includes stdout, 'Jane Smith', 'Should find results from stdin'
  end

  # Duplicate search tests
  def test_duplicates_search_with_file_long_option
    stdout, _, status = execute_client_search ['--duplicates', @client_json_path]

    assert status.success?, 'Should exit successfully'
    assert_includes stdout, 'Duplicate email search results:', 'Should show duplicates header'
    assert_includes stdout, 'Jane Smith (2)', 'Should find Jane Smith as a duplicate'
    assert_includes stdout, 'Another Jane Smith (15)', 'Should find Another Jane Smith as a duplicate'
  end

  def test_duplicates_search_with_file_short_option
    stdout, _, status = execute_client_search ['-d', @client_json_path]

    assert status.success?, 'Should exit successfully with -d'
    assert_includes stdout, 'Duplicate email search results:', 'Should show duplicates header'
    assert_includes stdout, 'Jane Smith (2)', 'Should find Jane Smith as a duplicate'
    assert_includes stdout, 'Another Jane Smith (15)', 'Should find Another Jane Smith as a duplicate'
  end

  def test_duplicates_search_no_duplicates
    stdout, _, status = execute_client_search ['--duplicates', @nodup_json_path]

    assert status.success?, 'Should exit successfully even with no duplicates'
    assert_includes stdout, 'Duplicate email search results:', 'Should show duplicates header'
    assert_includes stdout, 'No duplicate emails found', 'Should show no duplicates message'
  end

  def test_duplicates_search_with_stdin
    json_data = File.read(@client_json_path)
    stdout, _, status = execute_client_search ['--duplicates', stdin_data: json_data]

    assert status.success?, 'Should process stdin input for duplicates search'
    assert_includes stdout, 'Duplicate email search results:', 'Should show duplicates header'
    assert_includes stdout, 'Jane Smith', 'Should find duplicates from stdin'
  end

  # JSON error handling tests
  def test_invalid_json_with_name_search
    invalid_json = File.read(@invalid_json_path)
    stdout, _, status = execute_client_search ['--name', 'test', stdin_data: invalid_json]

    assert !status.success?, 'Should exit with error for invalid JSON'
    assert_includes stdout, 'Error:', 'Should show error message'
    assert_includes stdout, 'Invalid JSON format', 'Should show JSON parsing error'
  end

  def test_invalid_json_with_duplicates_search
    invalid_json = File.read(@invalid_json_path)
    stdout, _, status = execute_client_search ['--duplicates', stdin_data: invalid_json]

    assert !status.success?, 'Should exit with error for invalid JSON'
    assert_includes stdout, 'Error:', 'Should show error message'
  end

  def test_empty_json_array_name_search
    empty_json = '[]'

    stdout, _, status = execute_client_search ['--name', 'jane', stdin_data: empty_json]

    assert status.success?, 'Should handle empty JSON array'
    assert_includes stdout, "No matches found for 'jane'", 'Should show no matches for empty array'
  end

  def test_empty_json_array_duplicates_search
    empty_json = '[]'

    stdout, _, status = execute_client_search ['--duplicates', stdin_data: empty_json]

    assert status.success?, 'Should handle empty JSON array'
    assert_includes stdout, 'No duplicate emails found', 'Should show no duplicates for empty array'
  end

  # Output format tests
  def test_name_search_output_format
    json_data = [
      { 'id' => 42, 'full_name' => 'Anthony Answer', 'email' => '42@answer.com' }
    ].to_json

    stdout, _, status = execute_client_search ['--name', 'answer', stdin_data: json_data]

    assert status.success?
    assert_includes stdout, 'Anthony Answer (42) <42@answer.com>', 'Should format output using Client#to_s'
  end

  def test_duplicates_search_output_format
    duplicates_data = [
      { 'id' => 1, 'full_name' => 'User One', 'email' => 'same@example.com' },
      { 'id' => 2, 'full_name' => 'User Two', 'email' => 'same@example.com' }
    ].to_json

    stdout, _, status = execute_client_search ['--duplicates', stdin_data: duplicates_data]

    assert status.success?
    assert_includes stdout, 'Duplicate email: same@example.com', 'Should show duplicate email header'
    assert_includes stdout, '  User One (1) <same@example.com>', 'Should indent and format first duplicate'
    assert_includes stdout, '  User Two (2) <same@example.com>', 'Should indent and format second duplicate'
  end

  def test_name_search_no_filename_no_stdin
    stdout, _, status = execute_client_search ["--name", "jane"]

    assert !status.success?, "Should exit with error when no filename and no stdin"
    assert_includes stdout, "Usage:", "Should show usage message"
  end

  def test_duplicates_search_no_filename_no_stdin
    stdout, _, status = execute_client_search ["--duplicates"]

    assert !status.success?, "Should exit with error when no filename and no stdin"
    assert_includes stdout, "Usage:", "Should show usage message"
  end


  def execute_client_search(args = [])
    lib_path = File.expand_path('../lib', __dir__)
    # find the local ruby install and construct a working env to execute
    capture_args = [RbConfig.ruby, '-I', lib_path, @executable] + args
    Open3.capture3(*capture_args)
  end
end
