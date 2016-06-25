describe Person, type: :model do
  describe "validations" do
    it { should have_valid(:first_name).when("Name", "Another Name") }
    it { should_not have_valid(:first_name).when("", nil) }

    it { should have_valid(:last_name).when("Name", "Last Name", "", nil) }

    it { should have_valid(:email).when(*valid_emails) }
    it { should_not have_valid(:email).when(*invalid_emails) }
  end

  describe "associations" do
    it { should have_many(:person_availabilities) }
    it { should have_many(:slots).through(:person_availabilities) }
    it { should have_many(:members) }
    it { should have_many(:groups).through(:members) }
    it { should have_many(:scheduled_spots) }
  end
end
