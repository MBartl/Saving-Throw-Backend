class Api::AuthController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def create
    @user = User.find_by(username: user_login_params[:username])
    #User#authenticate comes from BCrypt
    if @user && @user.authenticate(user_login_params[:password])
      # encode token comes from ApplicationController
      token = encode_token({ user_id: @user.id })
      render json: { user: UserSerializer.new(@user), jwt: token }
    else
      render json: { errors: 'Invalid username or password' }
    end
  end

  def auto_login
    if session_user
      render json: session_user
    else
      render json: { errors: 'An unexpected error occured'}
    end
  end

  private
  def user_login_params
    params.require(:auth).permit(:username, :password)
  end
end
