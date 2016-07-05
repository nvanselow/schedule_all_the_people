require "rails_helper"

describe ScheduledSpot, type: :model do
  describe "validations" do
    it { should validate_presence_of(:person) }
    it { should validate_presence_of(:slot) }
  end

  describe "associations" do
    it { should belong_to(:person) }
    it { should belong_to(:slot) }
  end

  describe ".reschedule!" do

    let!(:person) { FactoryGirl.create(:person) }
    let!(:old_slot) { FactoryGirl.create(:slot) }
    let!(:new_slot) { FactoryGirl.create(:slot) }

    it "should move a person from one slot to another if previously scheduled" do
      old_slot.people << person

      saved = ScheduledSpot.reschedule!({
          person_id: person.id,
          new_slot_id: new_slot.id,
          old_slot_id: old_slot.id
        })

      expect(saved).to eq(true)
      expect(ScheduledSpot.all.count).to eq(1)
      updated_schedule_spot = ScheduledSpot.first
      expect(updated_schedule_spot.person_id).to eq(person.id)
      expect(updated_schedule_spot.slot_id).to eq(new_slot.id)
    end

    it "should create a new schedule spot if previously unscheduled" do
      saved = ScheduledSpot.reschedule!({
          person_id: person.id,
          new_slot_id: new_slot.id
        })

      expect(saved).to eq(true)
      expect(ScheduledSpot.all.count).to eq(1)
      updated_schedule_spot = ScheduledSpot.first
      expect(updated_schedule_spot.person_id).to eq(person.id)
      expect(updated_schedule_spot.slot_id).to eq(new_slot.id)
    end
  end
end
