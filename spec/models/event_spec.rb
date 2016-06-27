require "rails_helper"

describe Event, type: :model do
  describe "validations" do
    it { should have_valid(:name).when("Group Name", "Group") }
    it { should_not have_valid(:name).when("", nil) }

    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:group) }

    it { should have_valid(:slot_duration).when(1, 2, 20) }
    it { should_not have_valid(:slot_duration)
      .when("", nil, "not a number", 0.5, 0) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:blocks).dependent(:destroy) }
  end

  describe "#slots" do
    it "returns all of the slots across all blocks for an event" do
      event = FactoryGirl.create(:event)
      blocks = FactoryGirl.create_list(:block, 5, event: event)
      blocks.each { |block| FactoryGirl.create_list(:slot, 3, block: block) }

      slots = event.slots

      expect(slots.size).to eq(15)
    end
  end

  # describe "#slots_by_most_restricted" do
  #   it "returns all slots ordered by those that are most restricted by people" do
  #     event = FactoryGirl.create(:event)
  #     block = FactoryGirl.create(:block, event: event)
  #     test_slots = create_slots_of_varying_restrictions(block)
  #
  #     slots = event.slots_by_most_restricted
  #
  #     expect(slots[0].id).to eq(test_slots[:most_restricted_slot].id)
  #     expect(slots[1].id).to eq(test_slots[:middle_restricted_slot].id)
  #     expect(slots[2].id).to eq(test_slots[:least_restricted_slot].id)
  #   end
  #
  #   it "accounts for all slots across blocks" do
  #
  #   end
  # end

  xdescribe "#schedule!" do
    it "schedules all the people to available slots" do
      group = FactoryGirl.create(:group)
      group.people << FactoryGirl.create_list(:person, 5)
      event = FactoryGirl.create(:event, group: group)

      event.schedule!
    end
  end
end

def create_slots_of_varying_restrictions(block)
  middle_restricted_slot = FactoryGirl.create(:slot, block: block)
  FactoryGirl.create_list(:person_slot_restriction, 2, slot: middle_restricted_slot)

  least_restricted_slot = FactoryGirl.create(:slot, block: block)

  most_restricted_slot = FactoryGirl.create(:slot, block: block)
  FactoryGirl.create_list(:person_slot_restriction, 4, slot: most_restricted_slot)

  {
    least_restricted_slot: least_restricted_slot,
    middle_restricted_slot: middle_restricted_slot,
    most_restricted_slot: most_restricted_slot
  }
end
