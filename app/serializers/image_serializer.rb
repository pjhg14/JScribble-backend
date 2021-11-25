class ImageSerializer < ActiveModel::Serializer
  attributes :id, :url, :title, :description, :private

  belongs_to :user
end
