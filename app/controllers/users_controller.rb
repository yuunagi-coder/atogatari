class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(sign_up_params)
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: "ユーザーの新規登録に成功しました"}
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end

  private

  def sign_up_params
    params.expect(user: [:name, :email_address, :password, :password_confirmation])
  end
end
