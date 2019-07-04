class Api::UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def profile
    render json: { user: UserSerializer.new(current_user) }, status: :accepted
  end

  def create
    @user = User.create(user_params)
    if @user.valid? && params[:user][:password] === params[:user][:confirmation]
      token = encode_token(@user.id)
			render json: { user: UserSerializer.new(@user), token: token, path: 'signup' }, status: :accepted
    else
      @all_errors = ''
      @user.errors.full_messages.each do |error|
        if @all_errors === ''
          @all_errors += "#{error}"
        else
          @all_errors += ", #{error}"
        end
      end
      if params[:user][:password] != params[:user][:confirmation]
        @all_errors === '' ?
          @all_errors += "Passwords do not match" :
          @all_errors += ", Passwords do not match"
      end
      render json: { errors: @all_errors }, status: :not_acceptable
    end
  end

  private
  def user_params
    params.require(:user).permit(:username, :name, :password, :bio, :email, :age, :location)
  end
end
