class Record < ApplicationRecord
  belongs_to :user

  validates :spot_name, presence: true, length: { maximum: 30 }
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :recorded_at, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[memo recorded_at spot_name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end
end
