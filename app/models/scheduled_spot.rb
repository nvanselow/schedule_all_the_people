class ScheduledSpot < ActiveRecord::Base
  belongs_to :person
  belongs_to :slot

  validates :person, presence: true
  validates :slot, presence: true

  def self.reschedule!(person_id:, new_slot_id:, old_slot_id: nil)
    if(old_slot_id)
      old_scheduled_spot = where(slot_id: old_slot_id,
                                 person_id: person_id)
                                 .first
      old_scheduled_spot.destroy
    end

    scheduled_spot = ScheduledSpot.new(person_id: person_id,
                      slot_id: new_slot_id)

    return scheduled_spot.save
  end
end
