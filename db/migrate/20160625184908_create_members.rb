class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.belongs_to :group
      t.belongs_to :person
    end
  end
end
