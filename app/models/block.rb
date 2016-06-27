class Block < ActiveRecord::Base
  belongs_to :event
  has_many :slots, dependent: :destroy

  validates :start_time, presence: true, timeliness: { before: :end_time }
  validates :end_time, presence: true, timeliness: { after: :start_time }

  def duration
    return nil if (!start_time || !end_time)
    (end_time - start_time) / 60.to_f
  end

  def number_of_slots
    return 0 if (!start_time || !end_time)
    (duration / event.slot_duration.to_f).floor
  end

end
