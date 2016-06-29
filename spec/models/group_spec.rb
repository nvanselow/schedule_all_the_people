require "rails_helper"

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

  describe '.all_for_user' do

    let!(:user) { FactoryGirl.create(:user) }
    let!(:groups) { FactoryGirl.create_list(:group, 2, user: user) }

    it "returns all groups belonging to a user" do
      test_groups = Group.all_for_user(user)

      expect(test_groups.size).to eq(2)
      groups.each do |group|
        expect(test_groups).to include(group)
      end
    end

    it "returns an empty array if groups do not belong to user" do
      another_user = FactoryGirl.create(:user)

      test_groups = Group.all_for_user(another_user)

      expect(test_groups.size).to eq(0)
    end
  end

  describe '.find_for_user' do
    let!(:user) { FactoryGirl.create(:user) }
    let!(:group) { FactoryGirl.create(:group, user: user) }

    it "finds a group" do
      test_group = Group.find_for_user(group.id, user)

      expect(test_group).not_to be(nil)
      expect(test_group).to eq(group)
    end

    it "returns nil if the group does not belong to the user" do
      another_user = FactoryGirl.create(:user)

      test_group = Group.find_for_user(group.id, another_user)

      expect(test_group).to be(nil)
    end
  end
end
