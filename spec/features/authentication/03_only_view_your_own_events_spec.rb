require 'rails_helper'

feature "only view your own events" do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:event) { FactoryGirl.create(:event, user: user) }
  let(:malicious_user) { FactoryGirl.create(:user) }

  before do
    sign_in_as malicious_user
  end

  scenario "attempts to visit list of events" do
    visit events_path

    expect(page).not_to have_content(event.name)
  end

  scenario "attempts to visit event details" do
    visit event_path(event)

    expect(page).not_to have_content(event.name)
  end
end
