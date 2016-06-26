require "rails_helper"
require_relative '../../lib/modules/scheduler'

describe Scheduler, type: :model do

  describe ".new" do
    let(:event) { FactoryGirl.create(:event) }
    let(:scheduler) { Scheduler.new(event) }

    it "accepts an event as an argument" do
      expect { Scheduler.new(event) }.not_to raise_error
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
    let(:scheduler) { Scheduler.new(event) }

    it "returns true if everyone is scheduled" do
      add_slots(event)
      add_people(event)

      expect(scheduler.run).to be(true)
    end

    it "schedules each person" do
      slots = add_slots(event)
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
      add_slots(event)

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
      add_slots(event)
      event.group.people << FactoryGirl.create_list(:person, too_many_people)

      scheduler.run

      expect(scheduler.errors[0]).to eq("There are too few slots available. Either reduce the number of people or add more blocks.")
    end

    xit "returns a schedule with errors if someone cannot be scheduled due to restrictions" do
      add_slots(event)
      event.group.people << FactoryGirl.create_list(:person, number_of_people - 1)

      very_busy_person = FactoryGirl.create(:person)
      event.slots.each { |slot| very_busy_person.add_restriction(slot) }
      event.group.people << very_busy_person

      expect(scheduler.run).to be(false)
      expect(scheduler.errors.size).to be > 0
      expect(scheduler.errors).to include("Some people could not be scheduled.")
    end

    xit "does not schedule people for slots they have identifed as restricted" do
      slots = add_slots(event)

      busy_person = FactoryGirl.create(:person)
      slots.each { |slot| busy_person.add_restriction(slot) }
      busy_person.remove_restriction(slots[3])

      another_busy_person = FactoryGirl.create(:person)
      slots.each { |slot| another_busy_person.add_restriction(slot) }
      busy_person.remove_restriction(slots[2])
      busy_person.remove_restriction(slots[4])

      event.group.people << FactoryGirl.create_list(:person, number_of_people - 2)
      event.group.people << [busy_person, another_busy_person]

      expect(scheduler.run).to eq(true)
    end

    xit "finds a solution even if a few people have restrictions" do

    end
  end
end

def add_slots(event)
  blocks = FactoryGirl.create_list(:block, number_of_blocks, event: event)
  num_slots = number_of_slots / number_of_blocks
  slots = []
  blocks.each do |block|
    slots.concat(FactoryGirl.create_list(:slot, num_slots, block: block))
  end
  slots
end

def add_people(event)
  people = FactoryGirl.create_list(:person, number_of_people)
  event.group.people << people
  people
end
