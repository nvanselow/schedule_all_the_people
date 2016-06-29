require 'rails_helper'

feature "view details for a group" do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group, user: user) }

  before do
    sign_in_as user
  end

  scenario "visit the details page" do
    visit group_path(group.id)

    expect(page).to have_content(group.name)
  end

  scenario "there are no people in the group" do
    visit group_path(group.id)

    within(".people") do
      expect(page).to have_content("There are no people in this group")
      expect(page).not_to have_content("People")
    end
  end

  scenario "there are people in the group" do
    group.people << FactoryGirl.create_list(:person, 3)

    visit group_path(group.id)

    within(".people") do
      expect(page).to have_content("People")
      group.people.each do |person|
        expect(page).to have_content(person.email)
        expect(page).to have_content(person.name)
      end
    end
  end

  scenario "people in the group do not have names" do
    group.people << FactoryGirl.create_list(:person, 2,
                                            first_name: nil,
                                            last_name: nil)

    visit group_path(group.id)

    group.people do |person|
      expect(page).to have_content(person.email)
      expect(page).not_to have_content("()")
    end
  end
end
