describe EmailList do

  let(:emails) { "
      test1@test.com, test2@test.com, test3@test.com
    " }

  describe ".parse" do
    it "accepts an comma separated string of emails" do
      expect { EmailList.parse(emails) }
    end
  end
end
