class UsersController < ApplicationController
  before_action :logged_in?, only: [:profile, :update, :destroy]

  def index
    users = User.all

    render json: users
  end

  def show
    user = User.find_by(username: params[:username])

    render json: user
  end

  def profile
    # personal gallery page
    render json: @user
  end
  
  def create
    user = User.new(permit_params)

    if user.valid?
      user.save
      
      render json: user
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

  def destroy
    @user.images.destroy_all

    @user.destroy

    render json: {message: "User destroyed"}
  end
  
  private

  def permit_params
    params.require(:user).permit(:username, :password, :profile_img)
  end
  
  
end
