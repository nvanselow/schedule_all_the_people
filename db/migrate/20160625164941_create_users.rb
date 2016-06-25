class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uuid, null: false, index: true
      t.string :avatar_url
      t.string :first_name, null: false
      t.string :last_name
      t.string :email, null: false, index: true

      t.timestamps null: false
    end
  end
end
