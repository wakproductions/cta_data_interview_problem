class CreateCTAStopRoutes < ActiveRecord::Migration
  def change
    create_table :cta_stop_routes do |t|
      t.integer :cta_stop_id
      t.string :route_number

      t.timestamps null: false

    end
    add_index :cta_stop_routes, [:cta_stop_id, :route_number], unique: true
  end
end
