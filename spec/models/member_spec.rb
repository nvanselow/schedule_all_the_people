require "rails_helper"

describe Member, type: :model do
  describe "validations" do
    it { should validate_presence_of(:group) }
    it { should validate_presence_of(:person) }
  end

  describe "associations" do
    it { should belong_to(:group) }
    it { should belong_to(:person) }
  end
end
