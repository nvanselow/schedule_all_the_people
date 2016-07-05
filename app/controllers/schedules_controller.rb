class SchedulesController < ApplicationController
  include SlotsLeft
  helper_method :slots_left_to_create

  before_filter :authorize

  def create
    @event = Event.find_for_user(params[:event_id], current_user)

    scheduler = Modules::Scheduler.new(@event)

    if(scheduler.run)
      flash[:success] = "Schedule was generated!"
      @blocks = @event.blocks
      @schedule_errors = scheduler.errors
      render 'schedules/show'
    else
      flash[:alert] = "There were some problems generating your schedule. Please fix and then try generating again."
      @schedule_errors = scheduler.errors
      add_event_page_info
      render 'events/show'
    end
  end

  private

  def add_event_page_info
    @group = @event.group
    @blocks = @event.blocks
    @block = Block.new
  end
end
