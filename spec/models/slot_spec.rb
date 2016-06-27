require "rails_helper"

describe Slot, type: :model do
  describe "validations" do
    subject {
        FactoryGirl.build(:slot,
          start_time: '2014-10-31 20:00',
          end_time: '2016-01-23 18:00')
      }

    it { should have_valid(:available_spots).when(1, 2, 20) }
    it { should_not have_valid(:available_spots)
      .when("", nil, "not a number", 0.5, 0) }

    it { should validate_presence_of(:start_time) }
    it { should have_valid(:start_time).when(*valid_start_dates) }
    it { should_not have_valid(:start_time).when(*invalid_start_dates) }

    it { should validate_presence_of(:end_time) }
    it { should have_valid(:end_time).when(*valid_end_dates) }
    it { should_not have_valid(:end_time).when(*invalid_end_dates) }

    it { validate_presence_of(:block) }
    it { validate_presence_of(:person) }
  end

  describe "associations" do
    it { should belong_to(:block) }
    it { should have_many(:scheduled_spots).dependent(:destroy) }
    it { should have_many(:people).through(:scheduled_spots) }
    it { should have_many(:person_slot_restrictions).dependent(:destroy) }
  end

  describe ".create_slots_for_block" do
    let(:slot_duration) { 15 }
    let!(:event) { FactoryGirl.create(:event, slot_duration: 15) }

    it "creates enough slots to fill a block of time" do
      start_time = '2016-01-01 11:00'
      end_time = '2016-01-01 12:15'
      expected_slots = 5

      block = FactoryGirl.create(:block, start_time: start_time, end_time: end_time)

      slots = Slot.create_slots_for_block(block)

      expect(slots.size).to eq(expected_slots)
      expect(Slot.all.count).to eq(expected_slots)
      expect(slots[0].start_time).to eq('2016-01-01 11:00')
      expect(slots[0].end_time).to eq('2016-01-01 11:15')
      expect(slots[4].start_time).to eq('2016-01-01 12:00')
      expect(slots[4].end_time).to eq('2016-01-01 12:15')
    end

    it "does not create extra blocks if there is inexact times" do
      start_time = '2016-01-01 11:00'
      end_time = '2016-01-01 12:05'
      expected_slots = 4

      block = FactoryGirl.create(:block, start_time: start_time, end_time: end_time)

      slots = Slot.create_slots_for_block(block)

      expect(slots.size).to eq(expected_slots)
      expect(Slot.all.count).to eq(expected_slots)
      expect(slots[0].start_time).to eq('2016-01-01 11:00')
      expect(slots[3].end_time).to eq('2016-01-01 12:00')
    end
   end
end
