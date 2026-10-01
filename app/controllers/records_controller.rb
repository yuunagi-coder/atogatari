class RecordsController < ApplicationController
  before_action :set_record, only: [ :show, :edit, :destroy, :update ]
  before_action :authorize_user!, only: [ :edit, :update, :show ]

  include Respondable

  def new
    @record = Record.new
    @datetime = Time.current
  end

  def show
  end

  def index
    @q = Current.user.records.with_images.ransack(params[:q])
    @records = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(4)
  end

  def edit
    @datetime = @record.recorded_at
  end

  def create
    @record = Current.user.records.new(record_params)

    if !@record.photo.attached?
      @record.photo.attach(io: File.open(Rails.root.join("app", "assets", "images", "default_image.jpg")), filename: "default_image.jpg", content_type: "image/jpg")
    end
    if @record.save
      respond_with_success(root_path, message: "記録を作成しました", status: :created, location: @record)
    else
      respond_with_error(:new, @record)
    end
  end

  def update
    if @record.update(record_params)
      respond_with_success(@record, message: "記録を編集しました", status: :ok, location: @record)
    else
      respond_with_error(:edit, @record)
    end
  end

  def destroy
    @record.destroy
    redirect_to root_path, notice: "記録を削除しました"
  end

  private

  def set_record
    @record = Record.find(params[:id])
  end

  def record_params
    params.require(:record)
          .permit(:spot_name, :latitude, :longitude, :recorded_at, :memo, :photo)
          .merge(user_id: Current.user.id)
  end

  def authorize_user!
    redirect_to root_path, alert: '権限がありません' unless @record.user == Current.user
  end
end
