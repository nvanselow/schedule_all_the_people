class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.belongs_to :user, null: false
      t.string :provider, null: false
      t.string :access_token, null: false
      t.string :refresh_token
      t.datetime :expires_at

      t.timestamps null: false
    end
  end
end
