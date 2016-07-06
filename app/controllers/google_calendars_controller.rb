class GoogleCalendarsController < ApplicationController
  before_filter :authorize

  def index
    calendar_service = Modules::GoogleCalendar.new(current_user)
    calendar_service.get_calendars
  end

  def create
    @event = Event.find(params[:event_id])
    @blocks = @event.blocks

    calendar_service = Modules::GoogleCalendar.new(current_user)
    calendar_service.create_all_for(@event)

    flash[:success] = "Invitations have been sent. Check your Gmail calendar for more details."
    render 'show'
  end

end
