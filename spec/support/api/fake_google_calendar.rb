class FakeGoogleCalendar

  Calendar = Struct.new(:id, :name, :time_zone)

  def initialize(user)
    @user = user
  end

  def get_calendars
    [
      Calendar.new(1, 'test calendar 1', "Eastern Time (US & Canada)"),
      Calendar.new(2, 'test calendar 2', "Eastern Time (US & Canada)")
    ]
  end
end
