class AddProviderColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string, null: false, after: :uid
  end
end
