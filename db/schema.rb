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

ActiveRecord::Schema.define(version: 20170709180824) do

  create_table "crontab_actuators", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "histories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "start_time"
    t.datetime "stop_time"
    t.integer "valve_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hyperloop_connections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "channel"
    t.string "session"
    t.datetime "created_at"
    t.datetime "expires_at"
    t.datetime "refresh_at"
  end

  create_table "hyperloop_queued_messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "data"
    t.integer "connection_id"
  end

  create_table "porters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "host_name"
    t.string "port_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scheduled_sprinkle_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "sprinkle_id"
    t.integer "valve_id"
    t.integer "history_id"
    t.integer "valve_cmd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sprinkles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "next_start_time"
    t.datetime "base_start_time"
    t.string "state"
    t.string "time_input"
    t.integer "duration"
    t.integer "valve_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "valve_actuators", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "valve_id"
    t.integer "cmd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "valves", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.integer "gpio_pin"
    t.string "cpu2bb_color"
    t.integer "bb_pin"
    t.string "bb2relay_color"
    t.integer "relay_module"
    t.integer "relay_index"
    t.string "relay2valve_color"
    t.integer "cmd"
    t.datetime "base_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "water_managers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "state"
    t.string "http_host"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
