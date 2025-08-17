require 'json'
require_relative 'client_search/client'

class ClientSearch

  attr_reader :clients

  def initialize(json)
    @clients = JSON.parse(json)
    raise 'Expected a list of vales' unless @clients.is_a?(Array)
  rescue JSON::ParserError => e
    raise "Invalid JSON format. Error: #{e.message}"
  end

  def find_by_partial_name_match(partial_name: '')
    return [] if partial_name.nil? || partial_name.strip == ''
    clients
      .select { |h| h['full_name']&.downcase&.include?(partial_name.downcase) }
      .map { |h| Client.from(hash: h) }
  end

  def find_duplicate_emails
    clients
      .group_by { |client_hash| client_hash['email'] }
      .select { |_, hashes| hashes.length > 1 }
      .to_h
      .transform_values do |hashes|
        hashes.map { |h| Client.from(hash: h) }
      end
  end
end
