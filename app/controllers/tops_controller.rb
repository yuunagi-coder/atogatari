class TopsController < ApplicationController
  allow_unauthenticated_access only: %i[ top ]

  def top
    if authenticated?
      @records = Current.user.records.all.order(created_at: :desc)
      render :map
    else
      render :top
    end
  end
end
