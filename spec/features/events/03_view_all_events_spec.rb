require 'rails_helper'

feature "view all events" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:events) { FactoryGirl.create_list(:event, 4, user: user) }

  before do
    sign_in_as user
  end

  scenario "user visits the events index page" do
    visit events_path

    expect(page).to have_content("Events")
    events.each do |event|
      expect(page).to have_content(event.name)
    end
  end
end
