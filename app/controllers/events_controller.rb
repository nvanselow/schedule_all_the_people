class EventsController < ApplicationController
  include SlotsLeft
  helper_method :slots_left_to_create

  def show
    @event = Event.find(params[:id])
    @group = @event.group
    @blocks = @event.blocks
    @block = Block.new
  end

  def new
    @event = Event.new
    @groups = get_groups
  end

  def create
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
    params.require(:event).permit(:name, :group_id, :slot_duration)
  end

  def get_groups
    Group.all.collect { |group| [group.name, group.id] }
  end
end
