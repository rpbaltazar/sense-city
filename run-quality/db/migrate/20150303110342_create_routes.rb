class CreateRoutes < ActiveRecord::Migration
  def change
    create_table :routes do |t|
      t.st_point :centroid, geographic: true

      t.timestamps null: false
    end
  end
end
