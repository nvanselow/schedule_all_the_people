require 'rails_helper'

feature "drag and drop people on slots to reschedule", js: true do

  let!(:user) { FactoryGirl.create(:user) }
  let!(:person) { FactoryGirl.create(:person) }
  let!(:group) { FactoryGirl.create(:group, user: user) }
  let!(:member) { FactoryGirl.create(:member, group: group, person: person) }
  let!(:event) { FactoryGirl.create(:event, user: user, group: group) }
  let!(:block) { FactoryGirl.create(:block, event: event) }

  scenario "user drags a person on to an open slot" do
    sign_in_as user

    scheduler = Modules::Scheduler.new(event)
    scheduler.run

    visit event_schedules_path(event)

    person_div = page.find("#person_#{person.id}")
    slot_selector = "#slot_#{block.slots.last.id}"
    slot_div = page.find(slot_selector)
    person_div.drag_to(slot_div)

    # Drag_to is working, but cannot check it in the DOM
    # Refreshing the page makes sure the person was moved
    # and that it has been updated in the database from the
    # AJAX call.
    visit event_schedules_path(event)

    within("#slot_#{block.slots.first.id}") do
      expect(page).not_to have_content(person.email)
    end

    within(slot_selector) do
      expect(page).to have_content(person.email)
    end
  end
end
