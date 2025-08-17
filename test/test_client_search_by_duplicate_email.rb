require 'minitest/autorun'
require 'client_search'
require 'json'

class TestClientSearchByDuplicateEmail < Minitest::Test

  def setup
    client_json_path = File.join(__dir__, 'fixtures', 'clients.json')
    @client_json = File.read(client_json_path)
    empty_json_path = File.join(__dir__, 'fixtures', 'empty.json')
    @empty_json = File.read(empty_json_path)
    nodup_json_path = File.join(__dir__, 'fixtures', 'no_duplicate_emails.json')
    @nodup_json = File.read(nodup_json_path)
    multi_dup_json_path = File.join(__dir__, 'fixtures', 'multiple_duplicate_emails.json')
    @multi_dup_json = File.read(multi_dup_json_path)
  end

  def test_duplicates_finds_jane
    client_search = ClientSearch.new(@client_json)
    search_results = client_search.find_duplicate_emails
    assert_equal 1, search_results.length
    assert_equal 'jane.smith@yahoo.com', search_results.keys.first
    assert_equal 2, search_results['jane.smith@yahoo.com'][0].id
    assert_equal 15, search_results['jane.smith@yahoo.com'][1].id
  end

  def test_duplicates_finds_nothing_with_empty_json
    client_search = ClientSearch.new(@empty_json)
    search_results = client_search.find_duplicate_emails
    assert search_results.empty?, 'Results should be empty'
  end

  def test_duplicates_finds_nothing_with_no_duplicates
    client_search = ClientSearch.new(@nodup_json)
    search_results = client_search.find_duplicate_emails
    assert search_results.empty?, 'Results should be empty'
  end

  def test_duplicates_finds_multiple_duplicates
    client_search = ClientSearch.new(@multi_dup_json)
    search_results = client_search.find_duplicate_emails
    assert 3, search_results.length
    assert_equal [3, 4, 24, 34], search_results['alex.johnson@hotmail.com'].map(&:id)
    assert_equal [2, 15], search_results['jane.smith@yahoo.com'].map(&:id)
    assert_equal [17, 20, 22, 25], search_results['harper.scott@yandex.com'].map(&:id)
  end
end
