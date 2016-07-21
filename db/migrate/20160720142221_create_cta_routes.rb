class CreateCTARoutes < ActiveRecord::Migration
  def change
    create_table :cta_routes do |t|
      t.string :route_name

      t.timestamps null: false
    end

    add_index :cta_routes, :route_name, unique: true
  end
end
