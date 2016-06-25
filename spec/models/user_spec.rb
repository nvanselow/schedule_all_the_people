describe User, type: :model do

  describe "validations" do
    subject {FactoryGirl.build(:user) }

    it { should have_valid(:uuid).when("1235", 1235) }
    it { should_not have_valid(:uuid).when("", nil) }
    it { should validate_uniqueness_of(:uuid) }

    it { should have_valid(:avatar_url)
      .when("http://some_link.png", "/image/images.png", "image.jpg", "", nil) }

    it { should have_valid(:first_name).when("First", "A longer first name") }
    it { should_not have_valid(:first_name).when("", nil) }

    it { should have_valid(:last_name).when("Last", "A longer last name", "", nil) }

    it { should have_valid(:email).when(*valid_emails) }
    it { should_not have_valid(:email).when(*invalid_emails) }
    it { should validate_uniqueness_of(:email) }
  end

  describe "associations" do
    it { should have_many(:events).dependent(:destroy) }
    it { should have_many(:groups).dependent(:destroy) }
    it { should have_many(:people).through(:groups).class_name('Person').dependent(:destroy) }
  end

end
