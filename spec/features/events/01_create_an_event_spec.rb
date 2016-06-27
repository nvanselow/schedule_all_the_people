require 'rails_helper'

feature "create an event" do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group, user: user) }
  let(:event) { FactoryGirl.attributes_for(:event, group: group, user: user) }

  before do
    sign_in_as(user)
  end

  scenario "user correctly fills out the form to create a group" do
    visit new_event_path

    fill_in("Name", with: event[:name])
    select(group.name, from: "Group")
    fill_in("event_slot_duration", with: event[:slot_duration].to_s)
    click_button("Create Event")

    expect(page).to have_content("Event created")
    expect(page).to have_content(event[:name])
    expect(page).to have_content(group.name)
    expect(page).to have_content(event[:slot_duration])
  end

  scenario "user fills out the form incorrectly" do
    visit new_event_path

    click_button("Create Event")

    expect(page).to have_content("There was a problem creating that event")
    expect(page).to have_content("Name can't be blank")
  end
end
