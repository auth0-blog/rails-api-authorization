class Report < ApplicationRecord
  belongs_to :submitter, class_name: 'User'
  belongs_to :approver, class_name: 'User', optional: true
  belongs_to :expense

  validates :status, inclusion: { in: ['approved', 'rejected'] }, presence: true 
end
