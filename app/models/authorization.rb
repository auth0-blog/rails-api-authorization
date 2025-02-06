class Authorization < ApplicationRecord
  validates :store_id, presence: true, uniqueness: true
  validates :model_id, presence: true, uniqueness: true
end
