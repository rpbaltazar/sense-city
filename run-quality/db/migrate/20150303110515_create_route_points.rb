class CreateRoutePoints < ActiveRecord::Migration
  def change
    create_table :route_points do |t|
      t.references :route, index: true
      t.st_point :coordinates, geographic: true

      t.timestamps null: false
    end
    add_foreign_key :route_points, :routes
  end
end
