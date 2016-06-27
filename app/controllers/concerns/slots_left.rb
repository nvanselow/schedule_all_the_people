module SlotsLeft
  def slots_left_to_create
    @slots_left_to_create ||= calculate_slots_left_to_create
  end

  def calculate_slots_left_to_create
    number_of_people = @group.members.count
    number_of_slots = count_current_slots

    slots_left = number_of_people - number_of_slots

    if(slots_left < 0)
      0
    else
      slots_left
    end
  end

  def count_current_slots
    @event.blocks.reduce(0) do |total, block|
      total += block.number_of_slots
    end
  end

end
