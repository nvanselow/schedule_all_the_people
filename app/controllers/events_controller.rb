require_relative '../../lib/modules/google_calendar'

class EventsController < ApplicationController
  cattr_accessor :GoogleCalendar
  @@GoogleCalendar = GoogleCalendar

  include SlotsLeft
  helper_method :slots_left_to_create

  before_filter :authorize

  def index
    @events = Event.all_for_user(current_user)
  end

  def show
    @event = Event.find_for_user(params[:id], current_user)
    if(@event)
      @group = @event.group
      @blocks = blocks
      @block = Block.new
    else
      flash[:alert] = "That is not your event!"
      redirect_to root_path
    end
  end

  def new
    @event = Event.new
    @groups = get_groups
    @calendars = get_calendars
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user

    if(@event.save)
      flash[:success] = "Event created!"
      redirect_to event_path(@event)
    else
      @groups = get_groups
      @calendars = get_calendars

      flash[:alert] = "There was a problem creating that event."
      @errors = @event.errors.full_messages
      render 'events/new'
    end
  end

  def edit
    @event = Event.find_for_user(params[:id], current_user)
    @groups = get_groups
    @calendars = get_calendars
  end

  def update
    @event = Event.find_for_user(params[:id], current_user)

    if(@event.update(event_params))
      flash[:success] = "Event updated!"
      redirect_to event_path(@event)
    else
      @groups = get_groups
      @calendars = get_calendars

      flash[:alert] = "There was a problem updating the event."
      @errors = @event.errors.full_messages
      render 'events/edit'
    end
  end

  def destroy
    Event.find_for_user(params[:id], current_user).destroy
    flash[:success] = "Event deleted"
    redirect_to events_path
  end

  private

  def event_params
    split_calendar_id
    params.require(:event).permit(:name, :location, :group_id, :slot_duration, :calendar_id, :calendar_name)
  end

  def split_calendar_id
    calendar_string = params[:event][:calendar_id]
    calendar_array = calendar_string.split("::")
    params[:event][:calendar_id] = calendar_array[0]
    params[:event][:calendar_name] = calendar_array[1]
  end

  def get_groups
    Group.all_for_user(current_user).collect { |group| [group.name, group.id] }
  end

  def blocks
    @event.blocks.order(start_time: :asc)
  end

  def get_calendars
    calendar_service = @@GoogleCalendar.new(current_user)
    calendars = calendar_service.get_calendars
    calendars.map! do |calendar|
      [calendar.name, "#{calendar.id}::#{calendar.name}"]
    end
    calendars
  end
end
