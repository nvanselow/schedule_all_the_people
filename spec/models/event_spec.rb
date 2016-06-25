require "rails_helper"

describe Event, type: :model do
  describe "validations" do
    it { should have_valid(:name).when("Group Name", "Group") }
    it { should_not have_valid(:name).when("", nil) }

    it { validate_presence_of(:user) }
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
end
