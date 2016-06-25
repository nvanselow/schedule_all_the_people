class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.belongs_to :block

      t.integer :available_spots, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
    end
  end
end
