describe PersonAvailability, type: :model do
  describe "validations" do
    it { should validate_presence_of(:person) }
    it { should validate_presence_of(:slot) }
  end

  describe "associations" do
    it { should belong_to :person }
    it { should belong_to :slot }
  end
end
