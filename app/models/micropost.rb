class Micropost < ApplicationRecord
  MICROPOST_PARAMS = %i(content image).freeze

  belongs_to :user
  has_one_attached :image

  scope :order_by_created_at_desc, ->{order created_at: :desc}

  delegate :name, to: :user, prefix: true

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.validations.micropost.max_length_content}
  validates :image, content_type: {in: Settings.validations.micropost.valid_content_type},
                    size:
                    {less_than: Settings.validations.micropost.maxium_image_size.megabytes}

  def display_image
    image.variant resize_to_limit: [Settings.validations.image.img_size, Settings.validations.image.img_size]
  end
end
