class Block < ActiveRecord::Base
  belongs_to :event
  has_many :slots, dependent: :destroy

  validates :start_time, presence: true, timeliness: { before: :end_time }
  validates :end_time, presence: true, timeliness: { after: :start_time }
end
