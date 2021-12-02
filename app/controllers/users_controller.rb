class UsersController < ApplicationController
  before_action :logged_in?, only: [:process_token, :profile, :update, :upload, :deactivate]

  def login
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      render json: {confirmation: "success!", token: generate_token({user_id: user.id})}
    else
      render json: {error: "Unable to login", details: ["User not found: Incorrect username or password"]}
    end
  end

  def process_token
    render json: @user
  end

  def index
    users = User.all

    render json: users
  end

  def sample
    users = User.all.sample(20)

    render json: users
  end

  def show
    user = User.find(params[:id])

    render json: user

  rescue ActiveRecord::RecordNotFound
    render json: {error: "user not found"}
  end

  def find
    users = User.where("username LIKE ?", "%" + params[:username] + "%")
    
    render json: users
  end
  
  # i.e sign-up
  def create
    user = User.new(permit_params)

    if user.valid?
      user.save
      
      render json: {confirmation: "success!", token: generate_token({user_id: user.id})}
    else
      render json: {error: "Unable to create user", details: user.errors.full_messages}
    end
  end
  
  def update
    @user.assign_attributes(permit_params)

    if @user.valid?
      @user.save

      render json: @user
    else
      render json: {error: "Unable to update user", details: @user.errors.full_messages}
    end
  end

  def upload
    uploader = Cloudinary::Uploader.upload(params[:profile_img], use_filename: true, folder: "jscribble")
    
    @user.assign_attributes(profile_img: uploader["url"])

    if @user.valid?
      @user.save

      render json: @user
    else
      render json: {error: "Unable to update user", details: @user.errors.full_messages}
    end
  end
  
  def deactivate
    # get all image cloud_ids
    cloud_ids = @user.images.map {|image| image.cloud_id}


    # # destroy images in cloudinary
    Cloudinary::Api.delete_resources(cloud_ids)

    # # destroy images
    @user.images.destroy_all

    @user.destroy

    render json: {message: "User deactivated and related images destroyed"}
  end
  
  private

  def permit_params
    params.permit(:username, :password, :profile_img)
  end
  
  
end
