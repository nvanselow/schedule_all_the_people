describe Slot, type: :model do
  describe "validations" do
    subject {FactoryGirl.build(:slot) }

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
end
