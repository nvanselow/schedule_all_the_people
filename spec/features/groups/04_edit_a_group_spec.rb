require 'rails_helper'

feature "edit a group" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group, user: user) }
  let(:updated_name) { "Group Updated Name" }

  before do
    sign_in_as user
    visit edit_group_path(group.id)
  end

  scenario "user visit the edit page" do
    expect(page).to have_content("Edit a Group")
  end

  scenario "users updates the group correctly" do
    fill_in("Name", with: updated_name)
    click_button("Update Group")

    expect(page).to have_content("Group Updated")
    expect(page).to have_content(updated_name)
  end

  scenario "user enters an invalid group name" do
    fill_in("Name", with: "")
    click_button("Update Group")

    expect(page).to have_content("There was a problem updating the group")
    expect(page).to have_css(".errors")
    expect(page).to have_content("Name can't be blank")
  end
end
