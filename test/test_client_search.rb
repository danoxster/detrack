require 'minitest/autorun'
require 'client_search'

class TestClientSearch < Minitest::Test

  def setup
    client_json_path = File.join(__dir__, 'fixtures', 'clients.json')
    @client_json = File.read(client_json_path)
    invalid_json_path = File.join(__dir__, 'fixtures', 'invalid_clients.json')
    @invalid_json = File.read(invalid_json_path)
    not_list_json_path = File.join(__dir__, 'fixtures', 'not_a_list.json')
    @not_list_json = File.read(not_list_json_path)
  end

  def test_that_fixture_files_exists_and_is_parsable
    assert JSON.parse(@client_json), 'Fixture file does not exist at #{@client_json}'
  end

  def test_client_search_can_parse_json
    client_search = ClientSearch.new(@client_json)
    assert_instance_of ClientSearch, client_search, 'ClientSearch should be an instance of ClientSearch'
    assert client_search.clients.is_a?(Array), 'Clients should be an array'
  end

  def test_invalid_json_raises_error
    assert_raises(RuntimeError) do
      ClientSearch.new(@invalid_json)
    end
  end

  def test_json_that_is_not_a_list_raises_error
    assert_raises(RuntimeError) do
      ClientSearch.new(@not_list_json)
    end
  end
end
