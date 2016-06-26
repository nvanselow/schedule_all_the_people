require 'google/apis/calendar_v3'
require_relative 'google_client'

class GoogleCalendar
  include GoogleClient

  PROVIDER = 'google_oauth2'

  def initialize(user)
    @user = user
    @calendar = Google::Apis::CalendarV3::CalendarService.new
    @event = nil
    @slot = nil
  end

  def create_all_for(event)
    created_events = []
    event.slots.each do |slot|
      if(slot.people.size > 0)
        created_events << create_event(event, slot)
      end
    end
    created_events
  end

  def create_event(event, slot)
    @event = event
    @slot = slot

    calendar.insert_event('primary', google_event, send_notifications: true)
  end

  private

  def google_event
    google_event = Google::Apis::CalendarV3::Event.new
    google_event.summary = @event.name
    google_event.location = @event.location if @event.location

    start_time = slot.start_time.to_s
    end_time = slot.end_time.to_s

    google_event.start = Google::Apis::CalendarV3::EventDateTime.new(date_time: start_time)
    google_event.end = Google::Apis::CalendarV3::EventDateTime.new(date_time: end_time)
    google_event.attendees = google_attendees

    google_event
  end

  def google_attendees
    attendees = []
    @slot.people.each do |person|
      attendees << build_attendee(person)
    end
    attendees
  end

  def build_attendee(person)
    attendee = Google::Apis::CalendarV3::EventAttendee.new
    attendee.email = person.email
    attendee.display_name = person.name if person.name
  end

  def set_authorization
    token = @user.get_token(PROVIDER)
    @calendar.authorization = client_with_token(token)
  end
end
