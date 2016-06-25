class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.belongs_to :event, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
    end
  end
end
