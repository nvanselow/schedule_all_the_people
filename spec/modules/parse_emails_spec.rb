require_relative '../../lib/modules/email_list'

describe EmailList do
  let(:test_email) { "test1@test.com" }
  let(:emails) { "
      #{test_email}, test2@test.com, test3@test.com
    " }

  describe ".parse" do
    it "accepts an comma separated string of emails" do
      expect { EmailList.parse(emails) }.not_to raise_error
    end

    it "separates the list of email in to an array" do
      email_array = EmailList.parse(emails)

      expect(email_array.size).to eq(3)
      expect(email_array).to include(test_email)
    end
  end
end
