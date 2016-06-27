class Slot < ActiveRecord::Base
  belongs_to :block
  has_many :scheduled_spots, dependent: :destroy
  has_many :people, through: :scheduled_spots
  has_many :person_slot_restrictions, dependent: :destroy

  validates :available_spots, presence: true,
    numericality: { only_integer: true, greater_than: 0 }

  validates :start_time, presence: true, timeliness: { before: :end_time }
  validates :end_time, presence: true, timeliness: { after: :start_time }

  def self.create_slots_for_block(block)
    slot_duration = block.event.slot_duration
    slots = []

    block.number_of_slots.times do |n|
      start_time = block.start_time + (slot_duration * n).minutes
      end_time = block.start_time + (slot_duration * (n + 1)).minutes

      slots << Slot.find_or_create_by(block: block, start_time: start_time, end_time: end_time) do |slot|
        slot.block = block
        slot.available_spots = 1
        slot.start_time = start_time
        slot.end_time = end_time
      end
    end

    slots
  end
end
