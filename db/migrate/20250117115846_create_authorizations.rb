class CreateAuthorizations < ActiveRecord::Migration[7.0]
  def change
    create_table :authorizations do |t|
      t.string :store_id
      t.string :model_id

      t.timestamps
    end
  end
end
