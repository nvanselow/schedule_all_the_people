class PersonAvailability < ActiveRecord::Base
  belongs_to :person
  belongs_to :slot

  validates :person, presence: true
  validates :slot, presence: true
end
