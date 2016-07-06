require "rails_helper"
require_relative '../../lib/modules/scheduler'

describe Modules::Scheduler, type: :model do

  describe ".new" do
    let(:event) { FactoryGirl.create(:event) }
    let(:scheduler) { Modules::Scheduler.new(event) }

    it "accepts an event as an argument" do
      expect { Modules::Scheduler.new(event) }.not_to raise_error
    end

    it "has a reader for unscheduled slots" do
      expect(scheduler.unscheduled_slots.size).to eq(0)
    end

    it "has a reader for unscheduled people" do
      expect(scheduler.unscheduled_people.size).to eq(0)
    end

    it "has a reader for errors" do
      expect(scheduler.errors.size).to eq(0)
    end
  end

  describe "#run" do
    let(:number_of_blocks) { 2 }
    let(:number_of_slots) { 6 }
    let(:number_of_people) { 6 }
    let(:event) { FactoryGirl.create(:event) }
    let(:scheduler) { Modules::Scheduler.new(event) }

    it "returns true if everyone is scheduled" do
      add_blocks(event)
      add_people(event)

      expect(scheduler.run).to be(true)
    end

    it "schedules each person" do
      slots = add_blocks(event)
      people = add_people(event)

      expect(scheduler.run).to be(true)

      slots.each do |slot|
        expect(slot.people.size).to eq(1)
      end

      people.each do |person|
        expect(person.slots.size).to eq(1)
      end
    end

    it "returns false if there are any errors" do
      expect(scheduler.run).to be(false)
    end

    it "has an error if there are no people" do
      add_blocks(event)

      scheduler.run

      expect(scheduler.errors.size).to eq(1)
      expect(scheduler.errors[0]).to eq("There are no people in the group. Please add people and try again.")
    end

    it "has an error if there are no slots" do
      add_people(event)

      scheduler.run

      expect(scheduler.errors.size).to eq(1)
      expect(scheduler.errors[0]).to eq("There are no available slots. Please add open blocks and try again.")
    end

    it "has an error if there are too few slots for the number of people" do
      too_many_people = number_of_slots + 2
      add_blocks(event)
      event.group.people << FactoryGirl.create_list(:person, too_many_people)

      scheduler.run

      expect(scheduler.errors[0]).to eq("There are too few slots available. Either reduce the number of people or add more blocks.")
    end
  end
end

def add_blocks(event)
  block_duration = (number_of_slots * event.slot_duration) / number_of_blocks
  start_time = DateTime.new(2016, 01, 01, 15, 0, 0)
  end_time = start_time + block_duration.minutes
  blocks = FactoryGirl.create_list(:block, number_of_blocks,
                                    event: event,
                                    start_time: start_time,
                                    end_time: end_time)

  slots = []
  blocks.each do |block|
    slots.concat(Slot.create_slots_for_block_and_clean(block))
  end
  slots
end

def add_people(event)
  people = FactoryGirl.create_list(:person, number_of_people)
  event.group.people << people
  people
end
