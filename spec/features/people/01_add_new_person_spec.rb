require 'rails_helper'

feature "add people to a group" do

  let!(:group) { FactoryGirl.create(:group) }

  before do
    visit group_path(group)
  end

  scenario "user visits group details page and sees a form to add a person" do
    expect(page).to have_content("Add a Person")
  end

  scenario "user enters a valid person" do

  end

  scenario "user tries to submit a blank form" do

  end

  scenario "user tries to enter an invalid email" do

  end
end
