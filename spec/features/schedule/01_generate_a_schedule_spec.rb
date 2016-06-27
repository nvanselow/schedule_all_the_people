require 'rails_helper'

feature "generate a schedule" do

  let(:slot_duration) { 10 }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group, user: user) }
  let!(:event) { FactoryGirl.create(:event, group: group, user: user, slot_duration: slot_duration) }
  let(:start_time) { DateTime.new(2016, 1, 1, 11, 0, 0) }

  scenario "there are not enough block/slots created" do
    num_people = 5
    num_slots = 4
    end_time = start_time + (event.slot_duration * num_slots).minutes
    members = FactoryGirl.create_list(:member, num_people, group: group)
    block = FactoryGirl.create(:block, event: event, start_time: start_time, end_time: end_time)

    visit event_path(event)

    expect(page).to have_content("You have not created enough available blocks. Add more blocks to generate a schedule.")
  end

  scenario "enough blocks have been added to generate a schedule" do
    num_people = 5
    num_slots = 5
    end_time = start_time + (event.slot_duration * num_slots).minutes
    members = FactoryGirl.create_list(:member, num_people, group: group)
    block = FactoryGirl.create(:block, event: event, start_time: start_time, end_time: end_time)

    visit event_path(event)

    expect(page).to have_content("You have enough blocks open to generate a schedule for this group.")
  end

  scenario "user generates a schedule" do
    num_people = 5
    num_slots = 5
    end_time = start_time + (event.slot_duration * num_slots).minutes
    members = FactoryGirl.create_list(:member, num_people, group: group)
    block = FactoryGirl.create(:block, event: event, start_time: start_time, end_time: end_time)

    visit event_path(event)
    click_button("Generate Schedule")

    expect(page).to have_content("Schedule")
    expect(page).to have_content(event.name)
    expect(page).to have_content(block.start_time)
    members.each do |member|
      expect(page).to have_content(member.person.email)
    end
  end

  scenario "schedule is not doubled when regenerated" do
    num_people = 5
    num_slots = 5
    end_time = start_time + (event.slot_duration * num_slots).minutes
    members = FactoryGirl.create_list(:member, num_people, group: group)
    block = FactoryGirl.create(:block, event: event, start_time: start_time, end_time: end_time)

    visit event_path(event)
    click_button("Generate Schedule")
    visit event_path(event)
    click_button("Generate Schedule")

    expect(page).to have_content("Schedule")
    expect(page).to have_content(event.name)
    expect(page).to have_content(block.start_time)
    members.each do |member|
      expect(page).to have_content(member.person.email, count: 1)
    end
  end
end
