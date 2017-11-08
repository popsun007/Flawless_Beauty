class AddCalEventIdToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :cal_event_id, :string
  end
end
