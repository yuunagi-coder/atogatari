class RecordsController < ApplicationController
  before_action :set_record, only: [ :show, :edit, :destroy, :update ]

  def new
    @record = Record.new
    @datetime = Time.current
  end

  def show
  end

  def index
    @records = Current.user.records.all.order(created_at: :desc)
  end

  def edit
    @datetime = @record.recorded_at
  end

  def create
    @record = Current.user.records.new(record_params)
    respond_to do |format|
      if @record.save
        format.html { redirect_to root_path, notice: "記録を作成しました" }
        format.json { render :show, status: :created, location: @record }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @record.update(record_params)
        format.html { redirect_to @record, notice: "記録を編集しました"}
        format.json { render :show, status: :ok, location: @record }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
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
          .permit(:spot_name, :latitude, :longitude, :recorded_at, :memo)
          .merge(user_id: Current.user.id)
  end
end
