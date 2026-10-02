module Respondable
  extend ActiveSupport::Concern

  def respond_with_success(view, message:, status:, location:)
    respond_to do |format|
      format.html { redirect_to view, notice: message }
      format.json { render :show, status: status, location: location }
    end
  end

  def respond_with_error(view, model_name)
    respond_to do |format|
      format.html { render view, status: :unprocessable_entity }
      format.json { render json: model_name.errors, status: :unprocessable_entity }
    end
  end
end
