require 'rails_helper'

feature "handles google oauth token expiration" do

  let!(:user) { FactoryGirl.create(:user) }

  before do
    EventsController.GoogleCalendar = FakeGoogleCalendar
    sign_in_as(user)
  end

  scenario "user visits new event page with expired token" do
    FakeGoogleCalendar.turn_on_auth_errors

    visit new_event_path

    expect(current_path).to eq("/")

    FakeGoogleCalendar.turn_off_auth_errors
  end
end
