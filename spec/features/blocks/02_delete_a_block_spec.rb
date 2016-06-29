require 'rails_helper'

feature "delete a block from an event" do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:event) { FactoryGirl.create(:event, user: user) }
  let!(:blocks) { FactoryGirl.create_list(:block, 3, event: event) }

  before do
    sign_in_as user
  end

  scenario "user clicks the delete button for a block" do
    visit event_path(event)
    second_block = blocks[1]

    click_button("delete_#{second_block.id}")

    expect(page).to have_content("Block deleted")
    expect(page).to have_css(".block", count: 2)
  end
end
