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

ActiveRecord::Schema.define(version: 20170513114457) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name"
    t.string   "phone"
    t.boolean  "ability",                default: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "coordinator_payments", force: :cascade do |t|
    t.integer  "waiter_id"
    t.integer  "shift_id"
    t.float    "client_rate"
    t.float    "self_rate"
    t.boolean  "paid",        default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "managers", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "waiter_id"
    t.integer  "shift_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.float    "client_rate"
    t.float    "self_rate"
    t.boolean  "is_main",        default: false
    t.boolean  "is_coordinator", default: false
    t.boolean  "is_reserve",     default: false
    t.integer  "cost"
    t.boolean  "paid",           default: false
    t.boolean  "active",         default: false
  end

  create_table "reserve_payments", force: :cascade do |t|
    t.integer  "waiter_id"
    t.integer  "shift_id"
    t.boolean  "active",      default: false
    t.float    "client_rate"
    t.float    "self_rate"
    t.boolean  "paid",        default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "shifts", force: :cascade do |t|
    t.string   "rank"
    t.integer  "waiter_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.float    "selfrate"
    t.float    "clientrate"
    t.float    "hotelrate"
    t.date     "date"
    t.time     "start_time"
    t.time     "finish_time"
    t.float    "length"
    t.text     "comment"
    t.integer  "waiters_count"
    t.integer  "male_count"
    t.integer  "female_count"
  end

  create_table "waiters", force: :cascade do |t|
    t.string   "name"
    t.string   "rank"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.date     "estimate_date"
    t.string   "phone"
    t.date     "birthday"
    t.boolean  "health_book",          default: false
    t.date     "health_book_estimate"
    t.integer  "manager_id"
    t.string   "gender"
    t.string   "address"
    t.string   "second_phone"
    t.string   "passport_number"
    t.integer  "prepayment"
    t.integer  "prepayment_limit"
  end

end
