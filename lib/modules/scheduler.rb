class Scheduler
  attr_reader :unscheduled_slots, :unscheduled_people, :errors
  def initialize(event)
    @event = event
    @slots = slots_by_most_restricted
    @people = people_by_least_available.to_a
    @unscheduled_slots = []
    @unscheduled_people = []
    @errors = []
  end

  def run
    validate

    people_for_scheduling = @people.clone

    if(@errors.empty?)
      # This solution isn't great. Use all permutations solution, but not required for MVP
      # iterate through all the slots, assigning people
      # @slots.each do |slot|
      #   scheduled = false
      #   people_for_scheduling.each do |person|
      #     if(!person.slot_restrictions.include?(slot))
      #       slot.people << person
      #       people_for_scheduling.delete(person)
      #       scheduled = true
      #       break
      #     end
      #   end
      #
      #   if(!scheduled)
      #     @unscheduled_slots << slot
      #   end
      # end
      #
      # scheduled_people = Person.find_by_sql(["
      #   SELECT people.* FROM people
      #   JOIN scheduled_spots ON scheduled_spots.person_id = people.id
      #   JOIN slots ON slots.id = scheduled_spots.slot_id
      #   JOIN blocks ON blocks.id = slots.block_id
      #   WHERE blocks.event_id = ?
      # ", @event.id])
      #
      # @unscheduled_people = @people - scheduled_people

      @slots.each do |slot|
        slot.people << people_for_scheduling.pop()
      end

      if(people_for_scheduling.empty?)
        return true
      else
        @unscheduled_people = people_for_scheduling
        @errors << "Some people could not be scheduled."
      end

      if(!@unscheduled_slots.empty?)
        @errors << "There were some slots that could not be scheduled."
      end

      false
    else
      false
    end
  end

  private

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

  def slots_by_most_restricted
    @event.slots.sort_by do |slot|
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
