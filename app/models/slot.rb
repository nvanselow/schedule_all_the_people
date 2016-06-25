class Slot < ActiveRecord::Base
  belongs_to :block
  has_many :scheduled_spots, dependent: :destroy
  has_many :people, through: :scheduled_spots
  has_many :person_availabilities, dependent: :destroy

  validates :available_spots, presence: true,
    numericality: { only_integer: true, greater_than: 0 }

  validates :start_time, presence: true, timeliness: { before: :end_time }
  validates :end_time, presence: true, timeliness: { after: :start_time }
end
