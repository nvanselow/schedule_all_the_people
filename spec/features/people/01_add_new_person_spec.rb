require 'rails_helper'

feature "add people to a group" do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group, user: user) }
  let(:valid_person) { FactoryGirl.attributes_for(:person) }

  before do
    sign_in_as user
    visit group_path(group)
  end

  scenario "user visits group details page and sees a form to add a person" do
    within('.add-person') do
      expect(page).to have_css('form')
    end
  end

  scenario "user enters a valid person" do
    within('.add-person') do
      fill_in("Email", with: valid_person[:email])
      fill_in("First Name", with: valid_person[:first_name])
      fill_in("Last Name", with: valid_person[:last_name])
      click_button("Add Person")
    end

    expect(page).to have_content("Person added")
    expect(page).to have_content(valid_person[:email])
    expect(page).to have_content(valid_person[:first_name])
    expect(page).to have_content(valid_person[:last_name])
  end

  scenario "user tries to submit a blank form" do
    within('.add-person') do
      click_button("Add Person")
    end

    expect(page).to have_content('There was a problem adding that person')
    expect(page).to have_content("Email can't be blank")
  end

  scenario "user tries to enter an invalid email" do
    within('.add-person') do
      fill_in("Email", with: "some invalid email")
      click_button("Add Person")
    end

    expect(page).to have_content('There was a problem adding that person')
    expect(page).to have_content("Email is invalid")
  end
end
