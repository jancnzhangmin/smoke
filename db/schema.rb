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

ActiveRecord::Schema.define(version: 20180609085209) do

  create_table "accesstokens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "access_token"
    t.datetime "exptime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "username"
    t.string "login"
    t.string "password_digest"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins_roles", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "admin_id", null: false
    t.bigint "role_id", null: false
  end

  create_table "configs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "appid"
    t.text "secret"
    t.string "ioturl"
    t.string "callbackurl"
  end

  create_table "devicehistorylists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "sn"
    t.string "imsi"
    t.string "swver"
    t.string "hwver"
    t.float "vol", limit: 24
    t.integer "alarmstatus"
    t.string "rsrp"
    t.string "sinr"
    t.string "wsc"
    t.string "ctime"
    t.float "vol2", limit: 24
    t.datetime "ctimestramp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devicelogs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "sn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "sn"
    t.string "model"
    t.string "coordinate"
    t.string "address"
    t.string "floor"
    t.string "power"
    t.integer "powerstatu"
    t.datetime "reportTime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "timestamp"
    t.integer "status"
    t.string "imsi"
    t.string "swver"
    t.string "hwver"
    t.float "vol", limit: 24
    t.integer "user_id"
    t.integer "deleteflag"
  end

  create_table "devices_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "device_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "appkey"
    t.string "secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "accountsid"
    t.string "auth_token"
    t.string "appid"
    t.integer "isdefault"
    t.string "keyword"
    t.string "name"
  end

  create_table "mylogs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mytests", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "test"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.text "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "openid"
    t.string "headurl"
    t.string "phone"
    t.integer "sex"
    t.integer "status"
    t.integer "up_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "device_id"
    t.string "nickname"
    t.integer "alertsms"
    t.integer "alertwx"
    t.string "vercode"
    t.datetime "vertime"
  end

end
