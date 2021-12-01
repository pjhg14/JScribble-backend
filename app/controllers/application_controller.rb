class ApplicationController < ActionController::API
  def generate_token(payload)
    JWT.encode(payload, ENV["TOKEN_SECRET"])
  end

def logged_in?
  begin
    token = request.headers["Authorization"].split(" ")[1]
    user_id = JWT.decode(token, ENV["TOKEN_SECRET"])[0]["user_id"]
    
    @user = User.find(user_id)
  rescue 
    @user = nil 
  end

  render json: {
    error: "Please login", 
    details: "Something went wrong with login data, please login and try again"
  } unless @user
  end
end
