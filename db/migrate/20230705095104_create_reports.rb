class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.string :status, default: 'rejected', null: false
      t.references :submitter, foreign_key: { to_table: :users }
      t.references :approver, foreign_key: { to_table: :users }
      t.references :expense, foreign_key: { to_table: :expenses }
      t.timestamps
    end
  end
end
