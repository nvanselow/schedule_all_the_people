require_relative '../../lib/modules/google_calendar'

class GoogleCalendarsController < ApplicationController
  def create
    @event = Event.find(params[:event_id])
    calendar_service = GoogleCalendar.new(current_user)
    calendar_service.create_all_for(@event)

    flash[:success] = "Invitations have been sent. Check your Gmail calendar for more details."
    render 'schedules/show'
  end
end
