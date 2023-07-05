class User < ApplicationRecord
  has_many :expenses
  
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, presence: true
end
