class AddColorToCalendarEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :calendar_events, :color, :string
  end
end
