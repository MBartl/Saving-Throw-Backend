class Api::UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def profile
    render json: { user: UserSerializer.new(current_user) }
  end

  def create
    @user = User.create(user_params)
    if @user.valid? && params[:password] === params[:confirmation]
      token = encode_token(@user.id)
			render json: { user: UserSerializer.new(@user), token: token }
    else
      @all_errors = ''
      @user.errors.full_messages.each do |message|
        if @all_errors === ''
          @all_errors += "#{message}"
        else
          @all_errors += "<<|>> #{message}"
        end
      end
      render json: { errors: @all_errors }, status: :not_acceptable
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :name, :password, :bio, :email, :age, :location)
  end
end
