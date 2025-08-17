require "minitest/autorun"
require "client_search"

class TestClientSearch < Minitest::Test

  def setup
    @client_json_path = File.join(__dir__, 'fixtures', 'clients.json')
  end

  def test_that_fixture_file_exists
    assert File.exist?(@client_json_path), "Fixture file does not exist at #{@client_json_path}"
  end

  def test_client_search_can_parse_json
    client_search = ClientSearch.new(@client_json_path)
    assert_instance_of ClientSearch, client_search, "ClientSearch should be an instance of ClientSearch"
    assert client_search.clients.is_a?(Array), "Clients should be an array"
  end

  def test_invalid_json_raises_error
    invalid_json_path = File.join(__dir__, 'fixtures', 'invalid_clients.json')
    assert_raises(RuntimeError) do
      ClientSearch.new(invalid_json_path)
    end
  end
end
