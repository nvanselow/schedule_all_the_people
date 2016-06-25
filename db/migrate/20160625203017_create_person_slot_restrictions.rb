class CreatePersonSlotRestrictions < ActiveRecord::Migration
  def up
    drop_table :person_availabilities

    create_table :person_slot_restrictions do |t|
      t.belongs_to :person
      t.belongs_to :slot
    end
  end

  def down
    drop_table :person_slot_restrictions
    
    create_table :person_availabilities do |t|
      t.belongs_to :person, null: false
      t.belongs_to :slot, null: false

      t.timestamps null: false
    end
  end

end
