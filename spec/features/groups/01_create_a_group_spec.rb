require 'rails_helper'

feature "view groups of people to schedule" do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:groups) { FactoryGirl.create_list(:group, 3, user: user) }

  before do
    sign_in_as user
  end

  scenario "visit the list of current groups" do
    visit groups_path

    expect(page).to have_content("Groups")
    groups.each do |group|
      expect(page).to have_content(group.name)
    end
  end

  scenario "see how many people are in each of the groups" do
    groups[0].people << FactoryGirl.create_list(:person, 3)
    groups[1].people << FactoryGirl.create(:person)

    visit groups_path

    expect(page).to have_content("3 people")
    expect(page).to have_content("1 person")
    expect(page).to have_content("No people in this group")
  end
end
