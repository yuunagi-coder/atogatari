class TopsController < ApplicationController
  allow_unauthenticated_access only: %i[ top ]

  def top
    if authenticated?
      @q = Current.user.records.ransack(params[:q])
      @records = @q.result(distinct: true).order(created_at: :desc)
      render :map
    else
      render :top
    end
  end
end
