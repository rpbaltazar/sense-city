class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
      t.string :sensor_id
      t.st_point :coordinates, geographic: true

      t.timestamps null: false
    end
  end
end
