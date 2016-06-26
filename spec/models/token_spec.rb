describe Token, type: :model do
  describe "validations" do
    it { should validate_presence_of(:user) }
    it { should validate_presence_of(:provider) }
    it { should validate_presence_of(:access_token) }
    it { should validate_presence_of(:expires_at) }
    it { should have_valid(:expires_at).when(*valid_start_dates) }
    it { should_not have_valid(:expires_at).when(*invalid_start_dates) }
  end

  describe "associations" do
    it { should belong_to(:user) }
  end
end
