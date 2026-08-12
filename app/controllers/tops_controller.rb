class TopsController < ApplicationController
  allow_unauthenticated_access only: %i[ top ]

  def top
    if authenticated?
      render :map
    else
      render :top
    end
  end
end
