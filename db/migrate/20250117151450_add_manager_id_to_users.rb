class AddManagerIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :manager_id, :integer
  end
end
