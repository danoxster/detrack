require "minitest/autorun"
require "client_search"

class TestClientSearch < Minitest::Test
  def test_english_hello
    assert_equal "Hello from ClientSearch!", ClientSearch.say_hello
  end

end
