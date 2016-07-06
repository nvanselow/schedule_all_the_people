require 'rails_helper'

feature "view homepage when signed out" do

  let(:user) { FactoryGirl.create(:user) }

  scenario "user is not signed in" do
    visit root_path

    within(".content") do
      expect(page).to have_content("Please sign in using your Google account")
      expect(page).not_to have_content("Events")
    end

  end

  scenario "user is signed in but does not have any events" do
    sign_in_as user

    visit root_path

    within(".content") do
      expect(page).not_to have_content("Please sign in using your Google account")
      expect(page).to have_content("Events")
      expect(page).to have_content("No events have been created")
      expect(page).to have_link("Create an Event")
    end
  end

  scenario "user is signed in but does not have any groups" do
    sign_in_as user

    visit root_path

    within(".content") do
      expect(page).not_to have_content("Please sign in using your Google account")
      expect(page).to have_content("Groups")
      expect(page).to have_content("No groups have been created")
      expect(page).to have_link("Create a Group")
    end
  end

  scenario "user is signed in and has events" do
    events = FactoryGirl.create_list(:event, 2, user: user)
    sign_in_as user

    visit root_path

    within(".content") do
      expect(page).not_to have_content("Please sign in using your Google account")
      expect(page).to have_content("Events")
      expect(page).not_to have_content("No events have been created")

      events.each do |event|
        expect(page).to have_content(event.name)
      end
    end
  end

  scenario "user is signed in and has groups" do
    groups = FactoryGirl.create_list(:group, 2, user: user)
    sign_in_as user

    visit root_path

    within(".content") do
      expect(page).not_to have_content("Please sign in using your Google account")
      expect(page).to have_content("Groups")
      expect(page).not_to have_content("No groups have been created")

      groups.each do |group|
        expect(page).to have_content(group.name)
      end
    end
  end

  scenario "user clicks an event name on the homepage" do
    event = FactoryGirl.create(:event, user: user)
    sign_in_as user

    visit root_path
    click_link(event.name)

    expect(current_path).to eq(event_path(event))
  end

  scenario "user clicks a group name on the homepage" do
    group = FactoryGirl.create(:group, user: user)
    sign_in_as user

    visit root_path
    click_link(group.name)

    expect(current_path).to eq(group_path(group))
  end
end
