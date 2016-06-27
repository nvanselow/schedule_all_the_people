class Scheduler
  attr_reader :unscheduled_slots, :unscheduled_people, :errors
  def initialize(event)
    @event = event
    @people = people_by_least_available.to_a
    @unscheduled_slots = []
    @unscheduled_people = []
    @errors = []
  end

  def run
    create_slots

    validate

    if(@errors.empty?)
      schedule_everyone_without_restrictions
    else
      false
    end
  end

  private

  def create_slots
    @event.blocks.each do |block|
      Slot.create_slots_for_block(block)
    end
    
    @slots = slots_by_most_restricted
  end

  def schedule_everyone_without_restrictions
    @people_for_scheduling = @people.clone

    assign_people_to_slots

    post_validation
  end

  def assign_people_to_slots
    @slots.each do |slot|
      person = @people_for_scheduling.pop()
      slot.people << person if person
    end
  end

  def validate
    if(@people.empty?)
      @errors << "There are no people in the group. Please add people and try again."
    end

    if(@slots.empty?)
      @errors << "There are no available slots. Please add open blocks and try again."
    end

    # have to call .size twice because single .size returns a hash
    if(@errors.empty? && total_slots < @people.size)
      @errors << "There are too few slots available. Either reduce the number of people or add more blocks."
    end
  end

  def post_validation
    if(@people_for_scheduling.empty?)
      return true
    else
      @unscheduled_people = people_for_scheduling
      @errors << "Some people could not be scheduled."
    end

    if(!@unscheduled_slots.empty?)
      @errors << "There were some slots that could not be scheduled."
    end

    false
  end

  def slots_by_most_restricted
    Event.find(@event.id).slots.sort_by do |slot|
      -slot.person_slot_restrictions.size
    end
  end

  def people_by_least_available
    Person.select("people.*, COUNT(person_slot_restrictions.id) AS restrictions_count").
        joins("LEFT JOIN person_slot_restrictions ON person_slot_restrictions.person_id = people.id").
        joins("JOIN members ON members.person_id = people.id").
        where("members.group_id = ?", @event.group.id).
        group("people.id")
  end

  def total_slots
    @slots.reduce(0) do |total, slot|
      total + slot.available_spots
    end
  end
end
