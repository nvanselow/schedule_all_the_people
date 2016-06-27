class AddSlotDurationToEvents < ActiveRecord::Migration
  def change
    add_column :events, :slot_duration, :integer, null: false
  end
end
