class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.string :reason
      t.datetime :date
      t.references :submitter, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
