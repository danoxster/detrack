require "minitest/autorun"
require "client_search"

class TestClientSearch < Minitest::Test

  def setup
    @client_json_path = File.join(__dir__, 'fixtures', 'clients.json')
  end

  def test_fixture_path_setup
    assert File.exist?(@client_json_path), "Fixture file does not exist at #{@client_json_path}"
  end

  def test_hello
    assert_equal "Hello from ClientSearch!", ClientSearch.say_hello
  end

end
