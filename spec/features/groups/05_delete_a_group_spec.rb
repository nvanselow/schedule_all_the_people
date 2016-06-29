require 'rails_helper'

feature "delete a group" do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group, user: user) }

  before do
    sign_in_as user
  end

  scenario "user deletes a group" do
    visit groups_path

    click_button("Delete")

    expect(page).to have_content("Group deleted")
    expect(page).not_to have_content(group.name)
  end
end
