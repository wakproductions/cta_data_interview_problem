class CreateCTAStops < ActiveRecord::Migration
  def change
    create_table :cta_stops do |t|
      t.integer :cta_id
      t.string :on_street
      t.string :cross_street
      t.point :location

      t.timestamps null: false

    end
    add_index :cta_stops, [:cta_id], unique: true
  end
end
