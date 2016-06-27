require_relative '../../lib/modules/scheduler'

class SchedulesController < ApplicationController
  include SlotsLeft
  helper_method :slots_left_to_create

  def create
    @event = Event.find(params[:event_id])

    scheduler = Scheduler.new(@event)

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
