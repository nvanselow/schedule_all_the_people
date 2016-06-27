require 'rails_helper'

feature "add blocks to an event" do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:event) { FactoryGirl.create(:event, user: user) }
  let(:block) { FactoryGirl.attributes_for(:block) }

  scenario "user correctly adds a block" do
    visit event_path(event)

    fill_in("Start Time", with: block[:start_time])
    fill_in("End Time", with: block[:end_time])
    click_button("Add Block")

    expect(page).to have_content("Block Added")
    expect(page).to have_css('.block')
    expect(page).to have_content(block[:start_time])
    expect(page).to have_content(block[:end_time])
  end

  scenario "user attempts to add an invalid block" do
    visit event_path(event)

    click_button("Add Block")

    expect(page).to have_content("There was a problem adding the block")
    expect(page).to have_content("Start time can't be blank")
    expect(page).to have_content("End time can't be blank")
  end
end