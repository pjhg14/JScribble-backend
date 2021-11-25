class Image < ApplicationRecord
  belongs_to :user

  validates :url, presence: true, uniqueness: true
end
