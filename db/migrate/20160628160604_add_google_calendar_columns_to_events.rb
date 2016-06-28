class AddGoogleCalendarColumnsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :calendar_id, :string
    add_column :events, :calendar_name, :string
  end
end
