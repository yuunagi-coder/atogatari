class Record < ApplicationRecord
  belongs_to :user

  validates :spot_name, presence: true, length: { maximum: 30 }
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :recorded_at, presence: true
end
