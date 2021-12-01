class ImagesController < ApplicationController
  before_action :logged_in?, only: [:create, :update, :destroy]

  def index
    images = Image.all

    render json: images
  end

  def sample
    images = Image.where(private: false).sample(20)

    render json: images
  end

  def show
    image = Image.find(params[:id])

    render json: image

  rescue ActiveRecord::RecordNotFound
    render json: {error: "image not found"}
  end

  def find
    images = Image.where("lower(title) LIKE ?", "%#{params[:title].downcase}%")

    render json: images
  end

  def create
    uploader = Cloudinary::Uploader.upload(params[:image_data], folder: "jscribble/#{@user.username}")
    image = Image.new(permit_params.merge(user_id: @user.id, cloud_id: uploader["public_id"], url: uploader["secure_url"]))


    if image.valid?
      image.save
      
      render json: image
    else
      render json: {error: "Unable to upload image", details: image.errors.full_messages}
    end
  end
  
  def update
    image = Image.find(params[:id])
    image.assign_attributes(permit_params)

    if image.valid?
      image.save

      render json: image
    else
      render json: {error: "Unable to update image", details: image.errors.full_messages}
    end

  end

  def destroy
    image = Image.find(params[:id])

    Cloudinary::Api.delete_resources([image.cloud_id])

    image.destroy
  end
  
  private
  
  def permit_params
    params.permit(:title, :url, :description, :private)
  end
  
end
