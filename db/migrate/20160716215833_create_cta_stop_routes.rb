class CreateCTAStopRoutes < ActiveRecord::Migration
  def change
    create_table :cta_stop_routes do |t|
      t.integer :cta_stop_id
      t.integer :cta_route_id

      t.timestamps null: false

    end
    add_index :cta_stop_routes, [:cta_stop_id, :cta_route_id], unique: true
  end
end
