class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  # user作成・更新時の成功・失敗の挙動をconcernにまとめている
  include Respondable

  def new
    @user = User.new
  end

  def edit
    @user = Current.user
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
    respond_with_success(new_session_path, message: "ユーザーの新規登録に成功しました", status: :created, location: @user) 
    else
      respond_with_error(:new, @user)
    end
  end

  def update
    @user = Current.user

    if @user.update(user_params)
      respond_with_success(edit_user_path(@user), message: "ユーザーの更新に成功しました", status: :ok, location: @user)
    else
      respond_with_error(:edit, @user)
    end
  end


  private

  def user_params
    params.expect(user: [ :name, :email_address, :password, :password_confirmation ])
  end
end
