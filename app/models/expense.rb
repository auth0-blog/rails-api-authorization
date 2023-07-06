class Expense < ApplicationRecord
  belongs_to :submitter, class_name: 'User', foreign_key: :submitter_id
  has_many :reports, foreign_key: :submitter_id

  validates :reason, presence: true 
  validates :amount, presence: true, numericality: { greater_than: 0 }
  
  validates :date, presence: true
  validate :date_is_prior_to_today

  private

  def date_is_prior_to_today
    return if date.blank? || date <= Date.today

    errors.add(:date, "expense date must be prior or today")
  end
end
