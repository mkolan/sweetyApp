class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(users_params)
    if @user.save
      flash[:success] = "User registered successfully!!"
      redirect_to sugar_readings_path(current_user)
    else
      render :new
    end
  end

  private
    def users_params
      massAssignable = [:email, :password, :password_confirmation, :user_type]
      params.require(:user).permit(massAssignable)
    end

end