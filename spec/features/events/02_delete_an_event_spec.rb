require 'rails_helper'

feature "delete an event" do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:event) { FactoryGirl.create(:event, user: user) }

  before do
    sign_in_as user
  end

  scenario "user clicks the delete button" do
    visit events_path

    click_button("Delete")

    expect(page).to have_content("Event deleted")
    expect(page).not_to have_content(event.name)
  end

end
