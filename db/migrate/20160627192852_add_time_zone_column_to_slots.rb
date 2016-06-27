class AddTimeZoneColumnToSlots < ActiveRecord::Migration
  def change
    add_column :slots, :time_zone, :string, null: false, default: "Eastern Time (US & Canada)"
  end
end
