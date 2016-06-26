class RenameUidColumnOnUsers < ActiveRecord::Migration
  def change
    rename_column :users, :uuid, :uid
  end
end
