class Record < ApplicationRecord
  belongs_to :user
  before_create :default_photo

  validates :spot_name, presence: true, length: { maximum: 30 }
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :recorded_at, presence: true

  has_one_attached :photo

  def self.ransackable_attributes(auth_object = nil)
    %w[memo recorded_at spot_name]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end

  def default_photo
    if !self.photo.attatched?
      self.photo.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'top_page.png')), filename: 'default_image.png', content_type: 'image/png')
    end
  end
end
