namespace :openfga do
  desc "Create a store and authorization model"
  task create_store_and_model: :environment do
    store_id = OpenfgaService.create_store
    if store_id
      authorization_model_id = OpenfgaService.create_authorization_model(store_id)
      Authorization.create!(store_id: store_id, model_id: authorization_model_id)
      puts "Store ID: #{store_id}, Authorization Model ID: #{authorization_model_id}"
    else
      puts "Failed to create store"
    end
  end

  desc "Update relation"
  task update_relation: :environment do
    user = "anne"
    relation = "reader"
    object = "document:Z"
    result = OpenfgaService.update_relation(user, relation, object)
    puts "Update relation result: #{result}"
  end

  desc "Check authorization"
  task check_authorization: :environment do
    user = "anne"
    relation = "can_view"
    object = "document:Z"
    allowed = OpenfgaService.authorized?(user, relation, object)
    puts "Authorization check: #{allowed}"
  end
end
