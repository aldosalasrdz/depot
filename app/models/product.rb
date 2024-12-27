class Product < ApplicationRecord
  validates :title, :description, :image_url, presence: true
  validates :title, uniqueness: {
    message: "already in use, try another one."
  }
  validates :title, length: { minimum: 10 }
  validates :image_url, allow_blank: true, format: {
    with: %r{\.*\.(gif|jpg|png)\z}i,
    message: "must be a URL for GIF, JPG or PNG image"
  }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }
end
