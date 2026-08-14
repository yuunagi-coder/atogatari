class RecordsController < ApplicationController
  def new
    @record = Record.new
    @datetime = Time.current
  end

  def show
  end

  def index
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def record_params
    params.expect(:spot_name, :latitude, :longitude, :recorded_at, :memo, :user_id)
  end
end
