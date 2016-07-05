require 'google/apis/errors'

class FakeGoogleCalendar
  @@raise_auth_error = false

  Calendar = Struct.new(:id, :name, :time_zone)

  def initialize(user)
    @user = user
  end

  def get_calendars
    FakeGoogleCalendar.raise_auth_error if @@raise_auth_error

    [
      Calendar.new(1, 'test calendar 1', "Eastern Time (US & Canada)"),
      Calendar.new(2, 'test calendar 2', "Eastern Time (US & Canada)")
    ]
  end

  def self.raise_auth_error
    raise Google::Apis::AuthorizationError.new("Access token expired")
  end

  def self.turn_on_auth_errors
    @@raise_auth_error = true
  end

  def self.turn_off_auth_errors
    @@raise_auth_error = false
  end
end
