require 'rails_helper'

feature "delete a person from a group" do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group, user: user) }
  let!(:members) { FactoryGirl.create_list(:member, 3, group: group) }

  before do
    sign_in_as user
  end
  
  scenario "user deletes a person from a group" do
    visit group_path(group)

    person = members[1].person
    find("#delete_#{person.id}").click

    expect(page).not_to have_content(person.email)
    expect(page).to have_content(members[0].person.email)
    expect(page).to have_content(members[2].person.email)
  end
end
