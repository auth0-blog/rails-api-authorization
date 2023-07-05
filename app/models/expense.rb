class Expense < ApplicationRecord
  belongs_to :submitter, class_name: 'User'

  validates :reason, presence: true 
  validates :date, presence: true 
end
