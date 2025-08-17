require 'json'
require_relative 'client_search/client'

class ClientSearch

  attr_reader :clients

  def initialize(filename)
    json = File.read(filename)
    @clients = JSON.parse(json)
  rescue JSON::ParserError => e
    raise "Invalid JSON format in file: #{filename}. Error: #{e.message}"
  end

  def find_by_partial_name_match(partial_name: '')
    return [] if partial_name.nil? || partial_name.strip == ''
    clients
      .select { |h| h['full_name']&.downcase&.include?(partial_name.downcase) }
      .map { |h| Client.from(hash: h) }
  end
end
