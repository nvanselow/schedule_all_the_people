class Api::ScheduledSpotsController < ApplicationController
  before_filter :authorize

  def create
    if(ScheduledSpot.reschedule!(reschedule_params))
      render json: {
          slot_id: params[:slot][:new_slot_id],
          person_id: params[:slot][:person_id]
        }, status: :ok
    else
      render json: {
        message: 'There was a problem rescheduling that person.'
      }, status: :bad_request
    end
  end

  private

  def reschedule_params
    slot = params[:slot]

    {
      person_id: slot[:person_id],
      new_slot_id: slot[:new_slot_id],
      old_slot_id: slot[:old_slot_id]
    }
  end
end
