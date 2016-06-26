class AddGroupIdColumnToEvents < ActiveRecord::Migration
  def change
    add_column :events, :group_id, :integer, null: false, after: :user_id
  end
end
