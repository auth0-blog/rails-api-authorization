class User < ApplicationRecord
  has_many :expenses, foreign_key: :submitter_id
  has_many :submitted_reports, class_name: 'Report', foreign_key: 'submitter_id'
  has_many :reports_to_review, class_name: 'Report', foreign_key: 'approver_id'

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true, uniqueness: true
end
