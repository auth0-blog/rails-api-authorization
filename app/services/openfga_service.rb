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
end
