require 'rails_helper'

feature "create a new group" do
  let(:user) { FactoryGirl.create(:user) }
  let(:group_name) { "Test Group" }

  before do
    sign_in_as user
    visit new_group_path
  end

  scenario "user views form to create a group" do
    expect(page).to have_content("Create a New Group")
  end

  scenario "user fills out the form correctly" do
    fill_in("Name", with: group_name)
    click_button("Create a New Group")

    expect(page).to have_content("Group Created")
    expect(page).to have_content(group_name)
    expect(page).to have_content("There are no people in this group")
    expect(page).not_to have_css('.errors')
  end

  scenario "user leaves the name field blank" do
    click_button("Create a New Group")

    expect(page).to have_content("There was a problem creating that group")
    expect(page).to have_css('.errors')
    expect(page).to have_content("Name can't be blank")
  end
end
