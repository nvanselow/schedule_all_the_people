class AddTimeZoneColumnToBlocks < ActiveRecord::Migration
  def change
    add_column :blocks, :time_zone, :string, null: false, default: "Eastern Time (US & Canada)"
  end
end
