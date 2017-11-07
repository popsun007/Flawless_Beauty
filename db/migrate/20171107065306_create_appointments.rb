class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.datetime :time
      t.string :duration
      t.string :service
      t.text :note

      t.timestamps null: false
    end
  end
end
