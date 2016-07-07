require "rails_helper"

describe Person, type: :model do
  before do
    # Make sure all people are cleared from the database
    # before these test. Need to hunt down why peoples table
    # is persisting across tests.
    Person.destroy_all
  end

  describe "validations" do
    it { should have_valid(:first_name).when("Name", "Another Name", "", nil) }

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

  describe ".create_from_list" do
    let(:test_email) { "test@email.com" }

    it "creates people from a list of emails" do
      email_list = "#{test_email}; anotheremail@hotmail.com; third@gmail.com"

      bad_emails = Person.create_from_list(email_list)

      expect(bad_emails.empty?).to be(true)
      expect(Person.all.count).to eq(3)
    end

    it "returns nil if there are too many emails" do
      email_list = "#{test_email}"
      100.times do
        email_list << ";#{test_email}"
      end

      bad_emails = Person.create_from_list(email_list)
      expect(bad_emails).to be(nil)
    end

    it "returns an array of bad emails if there are invalid emails" do
      bad_email = "bad_email"
      bad_email_2 = "another bad one"
      email_list = "#{bad_email}, #{test_email}, #{bad_email_2}"

      bad_emails = Person.create_from_list(email_list)

      expect(bad_emails.size).to eq(2)
      expect(bad_emails[0].email).to eq(bad_email)
      expect(bad_emails[1].email).to eq(bad_email_2)
      expect(Person.all.count).to eq(1)
    end

    it "adds people to a group if a group is specified" do
      group = FactoryGirl.create(:group)
      email_list = "#{test_email}; anotheremail@hotmail.com; third@gmail.com"

      bad_emails = Person.create_from_list(email_list, group)

      expect(group.people.count).to eq(3)
      expect(group.people[0].email).to eq(test_email)
    end
  end

  describe "#name" do
    it "combines the first and last name if both specified" do
      person = FactoryGirl.create(:person)

      expect(person.name).to eq("#{person.first_name} #{person.last_name}")
    end

    it "only provides first name if last name is nil" do
      person = FactoryGirl.create(:person, last_name: nil)

      expect(person.name).to eq(person.first_name)
    end

    it "only provides first name if last name is blank" do
      person = FactoryGirl.create(:person, last_name: "")

      expect(person.name).to eq(person.first_name)
    end

    it "only provides the last name if the first name is nil" do
      person = FactoryGirl.create(:person, first_name: nil)

      expect(person.name).to eq(person.last_name)
    end

    it "only provides the last name if the first name is blank" do
      person = FactoryGirl.create(:person, first_name: "")

      expect(person.name).to eq(person.last_name)
    end

    it "returns nil if there is no first or last name" do
      person = FactoryGirl.create(:person, first_name: nil, last_name: nil)

      expect(person.name).to eq(nil)
    end

    it "returns nil if both first and last name are blank" do
      person = FactoryGirl.create(:person, first_name: "", last_name: "")

      expect(person.name).to eq(nil)
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
