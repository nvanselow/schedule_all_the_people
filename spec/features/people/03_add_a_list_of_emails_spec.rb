require "rails_helper"

feature "add a list of emails/people to a group" do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group, user: user) }
  let(:test_email) { "test@email.com" }
  let(:email_list) { "#{test_email}, another_email@email.com, abc@whatevs.com" }

  before do
    sign_in_as user
  end

  scenario "user adds a valid list of emails" do
    visit group_path(group)

    fill_in("List of Emails", with: email_list)
    click_button("Add All Emails")

    expect(page).to have_content("People added")
    expect(page).to have_content(test_email)
  end

  scenario "user adds a list that contains invalid emails" do
    bad_email = "bad_email"
    email_list = "#{test_email}, #{bad_email}"

    visit group_path(group)
    fill_in("List of Emails", with: email_list)
    click_button("Add All Emails")

    expect(page).to have_content("There was a problem with some of the emails you provided")

    within(".people") do
      expect(page).to have_content(test_email)
      expect(page).not_to have_content(bad_email)
    end

    within(".add-person") do
      expect(page).to have_content(bad_email)
    end
  end

  scenario "attempt to add too many people" do
    email_list = "#{test_email}"
    100.times do
      email_list << ",#{test_email}"
    end

    visit group_path(group)
    fill_in("List of Emails", with: email_list)
    click_button("Add All Emails")

    expect(page).to have_content("That are too many emails. Reduce the number of emails and try again.")
    within(".people") do
      expect(page).not_to have_content(test_email)
    end
  end
end
