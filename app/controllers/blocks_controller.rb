class BlocksController < ApplicationController
  include SlotsLeft
  helper_method :slots_left_to_create

  before_filter :authorize

  def create
    @event = Event.find_for_user(params[:event_id], current_user)
    @block = @event.blocks.new(block_params)

    if(@block.save)
      flash[:success] = "Block Added!"
      redirect_to event_path(@event)
    else
      flash[:alert] = "There was a problem adding the block"
      @errors = @block.errors.full_messages
      @group = @event.group
      @blocks = @event.blocks
      render 'events/show'
    end
  end

  def destroy
    Block.destroy(params[:id])
    flash[:success] = "Block deleted"

    @event = Event.find_for_user(params[:event_id], current_user)
    @group = @event.group
    @blocks = @event.blocks
    @block = Block.new
    render 'events/show'
  end

  private

  def block_params
    time_zone = params[:block][:time_zone]

    params[:block][:start_time] = set_timezone(params[:block][:start_time], time_zone)
    params[:block][:end_time] = set_timezone(params[:block][:end_time], time_zone)

    params.require(:block).permit(:start_time, :end_time)
  end

  def set_timezone(time, time_zone)
    ActiveSupport::TimeZone[time_zone].parse(time)
  end
end
