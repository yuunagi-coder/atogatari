class TopsController < ApplicationController
  allow_unauthenticated_access only: %i[ top ]

  def top
    if authenticated?
      @q = Current.user.records.ransack(params[:q])
      @result = @q.result(distinct: true).order(created_at: :desc)
      @records = @result.map do |record|
        {
          id: record.id,
          spot_name: record.spot_name,
          recorded_at: record.recorded_at,
          memo: record.memo,
          latitude: record.latitude,
          longitude: record.longitude,
          photo_url: record.photo.attached? ? url_for(record.photo) :nil
        }
      end
      render :map
    else
      render :top
    end
  end
end
