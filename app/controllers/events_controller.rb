require_relative '../../lib/modules/google_calendar'

class EventsController < ApplicationController
  include SlotsLeft
  helper_method :slots_left_to_create

  def show
    @event = Event.find(params[:id])
    @group = @event.group
    @blocks = blocks
    @block = Block.new
  end

  def new
    @event = Event.new
    @groups = get_groups
    @calendars = get_calendars
  end

  def create
    binding.pry
    @event = Event.new(event_params)
    @event.user = current_user

    if(@event.save)
      flash[:success] = "Event created!"
      redirect_to event_path(@event)
    else
      @groups = get_groups
      flash[:alert] = "There was a problem creating that event."
      @errors = @event.errors.full_messages
      render 'events/new'
    end
  end

  private

  def event_params
    split_calendar_id
    params.require(:event).permit(:name, :group_id, :slot_duration, :calendar_id, :calendar_name)
  end

  def split_calendar_id
    calendar_string = params[:event][:calendar_id]
    calendar_array = calendar_string.split("::")
    params[:event][:calendar_id] = calendar_array[0]
    params[:event][:calendar_name] = calendar_array[1]
  end

  def get_groups
    Group.all.collect { |group| [group.name, group.id] }
  end

  def blocks
    @event.blocks.order(start_time: :asc)
  end

  def get_calendars
    calendar_service = GoogleCalendar.new(current_user)
    calendars = calendar_service.get_calendars
    calendars.map! do |calendar|
      [calendar.name, "#{calendar.id}::#{calendar.name}"]
    end
    calendars
  end
end
