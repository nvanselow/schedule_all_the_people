class CreatePersonAvailabilities < ActiveRecord::Migration
  def change
    create_table :person_availabilities do |t|
      t.belongs_to :person, null: false
      t.belongs_to :slot, null: false

      t.timestamps null: false
    end
  end
end
