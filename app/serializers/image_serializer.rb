class ImageSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :description, :private

  has_one :user
end
