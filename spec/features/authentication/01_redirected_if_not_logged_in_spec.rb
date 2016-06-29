require 'rails_helper'

feature "can't visit auth protected pages if not logged in" do
  scenario "logged out user can visit homepage" do
    visit root_path

    expect(page).to have_content("Please sign in using your Google account to start using this web app.")
    expect(page).not_to have_content("Events")
    expect(page).not_to have_content("Groups")
  end

  scenario "attempts to visit groups page" do
    visit groups_path
    check_auth_error
  end

  scenario "attempts to create a new group" do
    visit new_group_path
    check_auth_error
  end

  scenario "attempts to edit a group" do
    group = FactoryGirl.create(:group)
    visit edit_group_path(group)
    check_auth_error
  end

  scenario "attempts to view a group" do
    group = FactoryGirl.create(:group)
    visit group_path(group)
    check_auth_error
  end

  scenario "attempts to view events" do
    visit events_path
    check_auth_error
  end

  scenario "attempts to create a new event" do
    visit new_event_path
    check_auth_error
  end

  scenario "attempts to edit an event" do
    event = FactoryGirl.create(:event)
    visit edit_event_path(event)
    check_auth_error
  end

  scenario "attempts to view an event" do
    event = FactoryGirl.create(:event)
    visit event_path(event)
    check_auth_error
  end
end
