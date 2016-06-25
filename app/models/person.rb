class Person < ActiveRecord::Base
  has_many :members
  has_many :groups, through: :members
  has_many :person_slot_restrictions
  has_many :scheduled_spots
  has_many :slots, through: :scheduled_spots

  validates :first_name, presence: true
  validates :email,
    presence: true,
    format: {
      with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
      message: "is invalid"
    }

  def self.all_by_availability
    get_all_with_availability_count.order("restrictions_count ASC")
  end

  def self.all_by_unavailability
    get_all_with_availability_count.order("restrictions_count DESC")
  end

  def add_event_availabilities(event)
    this.slots << event.slots
  end

  def add_availabilities(slots)
    this.slots << slots
  end

  def add_availability(slot)
    this.slots << slot
  end

  def remove_availability(slot)
    this.slots.destroy(slot)
  end


  private

  def self.get_all_with_availability_count
    select("people.*, COUNT(person_slot_restrictions.id) AS restrictions_count").
      joins("LEFT JOIN person_slot_restrictions ON person_slot_restrictions.person_id = people.id").
      group("people.id")
  end


end
