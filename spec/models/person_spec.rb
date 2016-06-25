require "rails_helper"

describe Person, type: :model do
  describe "validations" do
    it { should have_valid(:first_name).when("Name", "Another Name") }
    it { should_not have_valid(:first_name).when("", nil) }

    it { should have_valid(:last_name).when("Name", "Last Name", "", nil) }

    it { should have_valid(:email).when(*valid_emails) }
    it { should_not have_valid(:email).when(*invalid_emails) }
  end

  describe "associations" do
    it { should have_many(:person_slot_restrictions) }
    it { should have_many(:members) }
    it { should have_many(:groups).through(:members) }
    it { should have_many(:scheduled_spots) }
    it { should have_many(:slots).through(:scheduled_spots) }
  end

  describe ".all_by_availability" do
    it "returns all people ordered by their availability" do
      test_people = create_people_with_varying_availability

      people = Person.all_by_availability

      expect(people[0].id).to eq(test_people[:most_available_person].id)
      expect(people[1].id).to eq(test_people[:second_most_available_person].id)
      expect(people[2].id).to eq(test_people[:middle_available_person].id)
      expect(people[3].id).to eq(test_people[:least_available_person].id)
    end
  end

  describe ".all_by_unavailability" do
    it "returns all people with those with the fewest openings first" do
      test_people = create_people_with_varying_availability

      people = Person.all_by_unavailability

      expect(people[0].id).to eq(test_people[:least_available_person].id)
      expect(people[1].id).to eq(test_people[:middle_available_person].id)
      expect(people[2].id).to eq(test_people[:second_most_available_person].id)
      expect(people[3].id).to eq(test_people[:most_available_person].id)
    end
  end

  describe "#add_restriction" do
    it "adds a restriction to a person's schedule" do
      slot = FactoryGirl.create(:slot)
      person = FactoryGirl.create(:person)

      person.add_restriction(slot)

      expect(person.slot_restrictions.size).to eq(1)
    end

    it "only adds the expected slot" do
      slot = FactoryGirl.create(:slot)
      another_slot = FactoryGirl.create(:slot)
      person = FactoryGirl.create(:person)

      person.add_restriction(slot)

      expect(person.slot_restrictions.size).to eq(1)
    end
  end

  describe "#remove_restriction" do
    it "removes a restriction from a person's schedule" do
      slot = FactoryGirl.create(:slot)
      person = FactoryGirl.create(:person)
      person.slot_restrictions << slot

      person.remove_restriction(slot)

      expect(person.slot_restrictions.size).to eq(0)
    end

    it "only removes the expected slot" do
      slot = FactoryGirl.create(:slot)
      another_slot = FactoryGirl.create(:slot)
      person = FactoryGirl.create(:person)
      person.slot_restrictions << [slot, another_slot]

      person.remove_restriction(slot)

      expect(person.slot_restrictions.size).to eq(1)
    end
  end
end

def create_people_with_varying_availability
  middle_available_person = FactoryGirl.create(:person)
  FactoryGirl.create_list(:person_slot_restriction, 3, person: middle_available_person)

  second_most_available_person = FactoryGirl.create(:person)
  FactoryGirl.create_list(:person_slot_restriction, 1, person: second_most_available_person)

  least_available_person = FactoryGirl.create(:person)
  FactoryGirl.create_list(:person_slot_restriction, 7, person: least_available_person)

  most_available_person = FactoryGirl.create(:person)

  return {
    most_available_person: most_available_person,
    second_most_available_person: second_most_available_person,
    middle_available_person: middle_available_person,
    least_available_person: least_available_person
  }
end
