require 'minitest/autorun'
require 'client_search/client'

class TestClient < Minitest::Test

  def test_new
    client = Client.new(763, 'Vlad Dracul', 'dracula@castle.home')
    assert_equal 763, client.id
    assert_equal 'Vlad Dracul', client.full_name
    assert_equal 'dracula@castle.home', client.email
  end

  def test_to_s
    client = Client.new(423, 'Jendo Johansen', 'johansen@blamo.shop')
    assert_equal 'Jendo Johansen (423) <johansen@blamo.shop>', client.to_s
  end

  def test_from_hash
    hash = {
      'id' => -48435,
      'full_name' => 'Jackie Jormp-Jomp',
      'email' => 'big_tings@jam.jam'
    }
    client = Client.from(hash: hash)
    assert_equal (-48435), client.id
    assert_equal 'Jackie Jormp-Jomp', client.full_name
    assert_equal 'big_tings@jam.jam', client.email
  end

  def test_with_string_id
    hash = { 'id' => '90210' }
    client = Client.from(hash: hash)
    assert_equal (90210), client.id
  end

  def test_with_missing_values
    client = Client.from(hash: {})
    assert client.id.nil?, 'ID should be nil'
    assert client.full_name.nil?, 'full name should be nil'
    assert client.email.nil?, 'email should be nil'
  end
end
