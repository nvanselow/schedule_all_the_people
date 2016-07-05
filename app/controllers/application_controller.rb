require 'google/apis/errors'

class ApplicationController < ActionController::Base
  include ApplicationHelper
  include ActiveSupport::Rescuable

  rescue_from Google::Apis::AuthorizationError, :with => :handle_authorization_error

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :format_time

  def authorize
    if(!current_user)
      flash[:alert] = "Please login to visit that page."
      redirect_to root_path
    end
  end

  def handle_authorization_error
    redirect_to '/auth/google_oauth2'
  end
end
