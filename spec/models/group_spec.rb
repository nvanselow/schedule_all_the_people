feature Group, type: :model do

  describe "validations" do
    it { should have_valid(:name).when("Group Name", "Group") }
    it { should_not have_valid(:name).when("", nil) }

    it { should have_valid(:last_used).when(*valid_start_dates) }
    it { should_not have_valid(:last_used).when(*invalid_start_dates) }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should have_many(:members) }
    it { should have_many(:people).through(:members) }
  end

end
