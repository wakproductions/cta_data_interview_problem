class CreateCTARoutes < ActiveRecord::Migration
  def change
    create_table :cta_routes do |t|
      t.string :name

      t.timestamps null: false
    end

    add_index :cta_routes, :name, unique: true
  end
end
