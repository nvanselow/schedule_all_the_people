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
end
