require 'rails_helper'

feature "only view your own groups" do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group, user: user) }
  let(:malicious_user) { FactoryGirl.create(:user) }

  before do
    sign_in_as malicious_user
  end

  scenario "attempts to view list of groups" do
    visit groups_path

    expect(page).not_to have_content(group.name)
  end

  scenario "attempts to view group details" do
    visit group_path(group)

    expect(page).not_to have_content(group.name)
  end
end
