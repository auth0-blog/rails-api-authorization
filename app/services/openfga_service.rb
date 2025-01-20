require 'net/http'
require 'uri'
require 'json'
require 'pry'

class OpenfgaService

  def self.make_post_request(path, body:)
    uri = URI.parse("#{ENV['FGA_API_URL']}/#{path}")
    request = Net::HTTP::Post.new(uri)
    request.content_type = "application/json"
    request.body = body

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
  end

  def self.create_store
    response = make_post_request("stores", body: { name: "expenses" }.to_json)

    JSON.parse(response.body)["id"] if response.code.to_i == 201 
  end

  def self.create_authorization_model(store_id)
    response = make_post_request("stores/#{store_id}/authorization-models", 
    body: File.read(Rails.root.join('config', 'openfga_authorization_model.json')))

    JSON.parse(response.body)["authorization_model_id"] if response.code.to_i == 201
  end

  def self.update_relation(user, relation, object)
    return unless authorization_data

    store_id, authorization_model_id = authorization_data

    body = {
      writes: {
        tuple_keys: [
          {
            user: user,
            relation: relation,
            object: object
          }
        ]
      },
      authorization_model_id: authorization_model_id
    }.to_json

    response = make_post_request("stores/#{store_id}/write", body: body)

    response.body
  end

  def self.check(user, relation, object)
    return false unless authorization_data
    
    store_id, authorization_model_id = authorization_data

    body = {
      authorization_model_id: authorization_model_id,
      tuple_key: {
        user: user,
        relation: relation,
        object: object
      }
    }.to_json
    
    response = make_post_request("stores/#{store_id}/check", body: body)

    response.code.to_i == 200 ? JSON.parse(response.body)["allowed"] : false
  end
  
  def self.list_objects(user, relation)
    return unless authorization_data

    store_id, authorization_model_id = authorization_data

    body = {
      authorization_model_id: authorization_model_id,
      type: "report",
      relation: relation,
      user: "user:#{user.id}",
      context: {},
      consistency: "MINIMIZE_LATENCY"
    }.to_json

    response = make_post_request("stores/#{store_id}/list-objects", body: body)

    response.code.to_i == 200 ? JSON.parse(response.body)["objects"].map{|obj| obj.split(":")[1].to_i} : []
  end

  # atuhorized if at least one of the relations is allowed: true
  def self.batch_check_relations(user, relations, object)
    return unless authorization_data

    store_id, authorization_model_id = authorization_data
        
    checks = relations.map do |relation|
      {
        "tuple_key": {
          "user": user,
          "relation": relation,
          "object": object,
        },
      "correlation_id": SecureRandom.uuid 
      }
    end

    response = make_post_request("stores/#{store_id}/batch-check", 
                                 body: {authorization_model_id: "#{authorization_model_id}", checks: checks}.to_json)

    # # Response: 
    # {
    #   "results": {
    #     { "886224f6-04ae-4b13-bd8e-559c7d3754e1": { "allowed": false }}, # submmiter
    #     { "da452239-a4e0-4791-b5d1-fb3d451ac078": { "allowed": true }}, # approver
    #   }
    # } 
    # in our case if at least one of those is true, then the user can view the report. This is VERY specific for this 
    # use case!
    response.code.to_i == 200 ? JSON.parse(response.body)["result"].values.map{|e| e.values}.flatten.any? : false
  end

  private 
  def self.authorization_data
    authorization = Authorization.first
    [authorization&.store_id, authorization&.model_id] if authorization
  end

end
