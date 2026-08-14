class RecordsController < ApplicationController
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
  end

  def create
    @record = Current.user.records.new(record_params)
    respond_to do |format|
      if @record.save
        format.html { redirect_to root_path, notice: "思い出を記録しました" }
        format.json { render :show, status: :created, location: @record }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

  def destroy
  end

  private

  def record_params
    params.require(:record)
          .permit(:spot_name, :latitude, :longitude, :recorded_at, :memo)
          .merge(user_id: Current.user.id)
  end
end
