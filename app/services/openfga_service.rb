require 'net/http'
require 'uri'
require 'json'
require 'pry'

class OpenfgaService

  def self.create_store
    uri = URI.parse("#{ENV['FGA_API_URL']}/stores")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request.body = { name: "expenses" }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    JSON.parse(response.body)["id"] if response.code.to_i == 201 
  end

  def self.create_authorization_model(store_id)
    uri = URI.parse("#{ENV['FGA_API_URL']}/stores/#{store_id}/authorization-models")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request.body = File.read(Rails.root.join('config', 'openfga_authorization_model.json'))

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    JSON.parse(response.body)["authorization_model_id"] if response.code.to_i == 201
  end

  def self.update_relation(user, relation, object)
    return unless authorization_data

    store_id, authorization_model_id = authorization_data

    uri = URI.parse("#{ENV['FGA_API_URL']}/stores/#{store_id}/write")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request.body = {
      writes: {
        tuple_keys: [
          {
            user: "user:#{user}",
            relation: relation,
            object: "report:#{object}"
          }
        ]
      },
      authorization_model_id: authorization_model_id
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    response.body
  end

  def self.authorized?(user, relation, object)
    return false unless authorization_data
    
    store_id, authorization_model_id = authorization_data

    uri = URI.parse("#{ENV['FGA_API_URL']}/stores/#{store_id}/check")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request.body = {
      authorization_model_id: authorization_model_id,
      tuple_key: {
        user: "user:#{user}",
        relation: relation,
        object: "report:#{object}"
      }
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    JSON.parse(response.body)["allowed"]
  end

  private 
  def self.authorization_data
    authorization = Authorization.first
    [authorization&.store_id, authorization&.model_id] if authorization
  end

end
