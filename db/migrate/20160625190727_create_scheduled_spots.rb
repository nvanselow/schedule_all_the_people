class CreateScheduledSpots < ActiveRecord::Migration
  def change
    create_table :scheduled_spots do |t|
      t.belongs_to :person, null: false
      t.belongs_to :slot, null: false

      t.timestamps null: false
    end
  end
end
