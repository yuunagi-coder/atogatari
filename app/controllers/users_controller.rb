class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(sign_up_params)
    if @user.save
      start_new_session_for(@user)
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.expect(user: [:name, :email, :password, :password_confirmation])
  end
end
