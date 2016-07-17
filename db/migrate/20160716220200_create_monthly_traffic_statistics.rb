class CreateMonthlyTrafficStatistics < ActiveRecord::Migration
  def change
    create_table :monthly_traffic_statistics do |t|
      t.integer :cta_stop_id
      t.date :month_beginning
      t.string :day_type
      t.decimal :boardings
      t.decimal :alightings

      t.timestamps null: false
    end
    add_index :monthly_traffic_statistics, [:cta_stop_id, :month_beginning], unique: true, name: :monthly_traffic_statistics_unique_index
  end
end
