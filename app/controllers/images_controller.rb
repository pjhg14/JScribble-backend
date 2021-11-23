class ImagesController < ApplicationController
  before_action :logged_in?, only: [:create, :update, :destroy]

  def index
    image = Image.all
  end

  def show
    image = Image.find(params[:id])
  end

  def create
    url = Cloudinary::Uploader.upload(params[:url], use_filename: true, folder: "jscribble")
    image = Image.new(permit_params.merge({url: url}))

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

    image.destroy
  end
  
  private
  
  def permit_params
    params.require(:image).permit(:title, :description)
  end
  
end
