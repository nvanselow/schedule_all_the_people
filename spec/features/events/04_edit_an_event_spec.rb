require 'rails_helper'

feature "edit an event" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:event) { FactoryGirl.create(:event, user: user) }

  scenario "user visits the edit form" do
    visit events_path(event)

    click_link("Edit")

    expect(page).to have_content("Edit Event")
    expect(page).to have_css('form')
    expect(page).to have_field("Name", with: event.name)
    expect(page).to have_select('Select a Google Calendar')
  end

  scenario "user edits the form correctly" do
    updated_name = "Updated Event"
    updated_location = "Updated location"
    updated_slot_duration = 55
    updated_calendar = "test calendar 2"
    updated_group = FactoryGirl.create(:group, user: user)

    visit edit_event_path(event)

    fill_in("Name", with: updated_name)
    fill_in("Location", with: updated_location)
    fill_in("Slot Duration (in min)", with: updated_slot_duration)
    select(updated_calendar, from: "Select a Google Calendar")
    select(updated_group.name, from: "Select a Group")
    click_button("Save")

    expect(page).to have_content("Event updated")
    expect(page).to have_content(updated_name)
    expect(page).not_to have_content(event.name)
    expect(page).to have_content(updated_location)
    expect(page).to have_content(updated_slot_duration)
    expect(page).to have_content(updated_calendar)
    expect(page).to have_content(updated_group.name)
  end

  scenario "user submits an event without a name" do
    visit edit_event_path(event)

    fill_in("Name", with: "")
    click_button("Save")

    expect(page).to have_content("There was a problem updating the event")
    expect(page).to have_content("Name can't be blank")
  end
end
