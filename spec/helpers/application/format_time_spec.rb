require 'rails_helper'

describe ApplicationHelper do

  let(:helper) do
    dummy_class = Object.new
    dummy_class.extend(ApplicationHelper)
  end

  describe "#format_time" do
    it "converts a time to a user readable string" do
      time = ActiveSupport::TimeWithZone.new('2016-06-27 19:05:00', 'UTC')
      time_zone = 'Eastern Time (US & Canada)'

      expect(helper.format_time(time, time_zone)).to eq('6/27/16 7:05 PM')
    end

    it "has an option to leave off the date" do
      time = ActiveSupport::TimeWithZone.new('2016-06-27 19:05:00', 'UTC')
      time_zone = 'Eastern Time (US & Canada)'

      expect(helper.format_time(time, time_zone, :time_only)).to eq('7:05 PM')
    end

    it "has the option to only display the date" do
      time = ActiveSupport::TimeWithZone.new('2016-06-27 19:05:00', 'UTC')
      time_zone = 'Eastern Time (US & Canada)'

      expect(helper.format_time(time, time_zone, :date_only)).to eq('6/27/16')
    end
  end
end
