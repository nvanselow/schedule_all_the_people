class BlocksController < ApplicationController

  def create
    @event = Event.find(params[:event_id])
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

  private

  def block_params
    params.require(:block).permit(:start_time, :end_time)
  end
end
