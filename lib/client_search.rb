require 'json'
class ClientSearch

  attr_reader :clients

  def initialize(filename)
    json = File.read(filename)
    @clients = JSON.parse(json)
  rescue JSON::ParserError => e
    raise "Invalid JSON format in file: #{filename}. Error: #{e.message}"
  end


end
