require "rails_helper"

describe Block, type: :model do
  describe "validations" do
    subject {FactoryGirl.build(:block) }

    it { should validate_presence_of(:start_time) }
    it { should have_valid(:start_time).when(*valid_start_dates) }
    it { should_not have_valid(:start_time).when(*invalid_start_dates) }

    it { should validate_presence_of(:end_time) }
    it { should have_valid(:end_time).when(*valid_end_dates) }
    it { should_not have_valid(:end_time).when(*invalid_end_dates) }

    it { validate_presence_of(:event) }
  end

  describe "associations" do
    it { should belong_to(:event) }
    it { should have_many(:slots).dependent(:destroy) }
  end

  describe "#duration" do
    let(:start_time) { DateTime.new(2016, 01, 01, 11, 0, 0) }

    it "gets the duration (in minutes) of the block" do
      duration = 75
      end_time = start_time + duration.minutes
      block = FactoryGirl.create(:block, start_time: start_time, end_time: end_time)

      expect(block.duration).to eq(duration)
    end

    it "gets the duration for uneven times" do
      duration = 22
      end_time = start_time + duration.minutes
      block = FactoryGirl.create(:block, start_time: start_time, end_time: end_time)

      expect(block.duration).to eq(duration)
    end
  end

  describe "#number_of_slots" do
    it "gets the number of slots required to fill the block" do
      duration = 60
      slot_duration = 20
      expected_number_of_slots = 3
      event = FactoryGirl.create(:event, slot_duration: slot_duration)

      start_time = DateTime.new(2016, 01, 01, 11, 0, 0)
      end_time = start_time + duration.minutes
      block = FactoryGirl.create(:block, event: event, start_time: start_time, end_time: end_time)

      expect(block.number_of_slots).to eq(expected_number_of_slots)
    end
  end
end
