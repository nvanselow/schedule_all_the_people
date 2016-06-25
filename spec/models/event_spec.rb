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
end
