require_relative '../../lib/modules/google_calendar'
require_relative '../../lib/modules/google_client'

class GoogleCalendarsController < ApplicationController
  include ActiveSupport::Rescuable

  rescue_from Google::Apis::AuthorizationError, :with => :handle_authorization_error

  def index
    calendar_service = GoogleCalendar.new(current_user)
    calendar_service.get_calendars
  end

  def create
    @event = Event.find(params[:event_id])
    @blocks = @event.blocks

    calendar_service = GoogleCalendar.new(current_user)
    calendar_service.create_all_for(@event)

    flash[:success] = "Invitations have been sent. Check your Gmail calendar for more details."
    render 'show'
  end

  private

  def handle_authorization_error
    redirect_to '/auth/google_oauth2'
  end
end
