# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160720142221) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cta_routes", force: :cascade do |t|
    t.string   "route_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cta_routes", ["route_name"], name: "index_cta_routes_on_route_name", unique: true, using: :btree

  create_table "cta_stop_routes", force: :cascade do |t|
    t.integer  "cta_stop_id"
    t.integer  "cta_route_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "cta_stop_routes", ["cta_stop_id", "cta_route_id"], name: "index_cta_stop_routes_on_cta_stop_id_and_cta_route_id", unique: true, using: :btree

  create_table "cta_stops", force: :cascade do |t|
    t.integer  "cta_id"
    t.string   "on_street"
    t.string   "cross_street"
    t.point    "location"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "cta_stops", ["cta_id"], name: "index_cta_stops_on_cta_id", unique: true, using: :btree

  create_table "monthly_traffic_statistics", force: :cascade do |t|
    t.integer  "cta_stop_id"
    t.date     "month_beginning"
    t.string   "day_type"
    t.decimal  "boardings"
    t.decimal  "alightings"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "monthly_traffic_statistics", ["cta_stop_id", "month_beginning"], name: "monthly_traffic_statistics_unique_index", unique: true, using: :btree

end
