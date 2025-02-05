module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      flash[:alert] = "The requested resource was not found."
      redirect_to root_path
    end

    rescue_from ActionController::ParameterMissing do |e|
      flash[:alert] = "Required parameters are missing."
      redirect_back(fallback_location: root_path)
    end
  end
end
