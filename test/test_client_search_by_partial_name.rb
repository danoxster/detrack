require 'minitest/autorun'
require 'client_search'

class TestClientSearchByPartialName < Minitest::Test

  def setup
    client_json_path = File.join(__dir__, 'fixtures', 'clients.json')
    @client_json = File.read(client_json_path)
  end

  def test_all_janes_are_found
    search_string = 'Jane'
    client_search = ClientSearch.new(@client_json)
    search_results = client_search.find_by_partial_name_match(partial_name: search_string)
    assert_equal 2, search_results.length
    assert_equal 2, search_results[0].id
    assert_equal 15, search_results[1].id
  end

  def test_case_insensitive_search
    search_string = 'john'
    client_search = ClientSearch.new(@client_json)
    search_results = client_search.find_by_partial_name_match(partial_name: search_string)
    assert_equal 2, search_results.length
    assert_equal 1, search_results[0].id
    assert_equal 3, search_results[1].id
  end

  def test_with_whitespace
    search_string = 'a l'
    client_search = ClientSearch.new(@client_json)
    search_results = client_search.find_by_partial_name_match(partial_name: search_string)
    assert_equal 2, search_results.length
    assert_equal 12, search_results[0].id
    assert_equal 19, search_results[1].id
  end

  def test_with_family_name
    search_string = 'Brown'
    client_search = ClientSearch.new(@client_json)
    search_results = client_search.find_by_partial_name_match(partial_name: search_string)
    assert_equal 2, search_results.length
    assert_equal 5, search_results[0].id
    assert_equal 10, search_results[1].id
  end

  def test_with_nil_input
    client_search = ClientSearch.new(@client_json)
    search_results = client_search.find_by_partial_name_match(partial_name: nil)
    assert search_results.empty?, 'Search results should be empty'
  end

  def test_with_no_input
    client_search = ClientSearch.new(@client_json)
    search_results = client_search.find_by_partial_name_match
    assert search_results.empty?, 'Search results should be empty'
  end

  def test_with_whitespace_input
    client_search = ClientSearch.new(@client_json)
    search_results = client_search.find_by_partial_name_match(partial_name: '\n ')
    assert search_results.empty?, 'Search results should be empty'
  end

  def test_with_no_matches
    search_string = 'this is not a name that exists in the test data'
    client_search = ClientSearch.new(@client_json)
    search_results = client_search.find_by_partial_name_match(partial_name: search_string)
    assert search_results.empty?, 'Search results should be empty'
  end
end
