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

  describe "#all_for_user" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:events) { FactoryGirl.create_list(:event, 3, user: user) }

    it "returns all events for a user" do
      test_events = Event.all_for_user(user)

      expect(test_events.size).to eq(3)
      events.each do |event|
        expect(test_events).to include(event)
      end
    end

    it "returns an empty array if no events for user" do
      another_user = FactoryGirl.create(:user)

      test_events = Event.all_for_user(another_user)

      expect(test_events.size).to eq(0)
    end
  end

  describe ".find_for_user" do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:event) { FactoryGirl.create(:event, user: user) }

    it "returns an event belonging to a user" do
      test_event = Event.find_for_user(event.id, user)

      expect(test_event).to eq(event)
    end

    it "returns nil if event does not belong to user" do
      another_user = FactoryGirl.create(:user)

      test_event = Event.find_for_user(event.id, another_user)

      expect(test_event).to eq(nil)
    end
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
