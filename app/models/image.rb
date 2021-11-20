class Image < ApplicationRecord
  has_one :user

  validates :url, presence: true, uniqueness: true
end
