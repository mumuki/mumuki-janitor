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

ActiveRecord::Schema.define(version: 20170526192407) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_clients", force: :cascade do |t|
    t.string   "description"
    t.string   "token"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string   "uid"
    t.string   "slug"
    t.string   "days",                         array: true
    t.string   "code"
    t.string   "shifts",                       array: true
    t.string   "period"
    t.string   "description"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "logo_url"
    t.boolean  "public",                   default: false
    t.string   "contact_email"
    t.text     "theme_stylesheet"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.text     "books",                    default: [],                 array: true
    t.string   "locale"
    t.text     "terms_of_service"
    t.text     "login_methods",            default: [],                 array: true
    t.string   "theme_stylesheet_url"
    t.text     "extension_javascript"
    t.string   "extension_javascript_url"
    t.string   "community_link"
    t.index ["name"], name: "index_organizations_on_name", using: :btree
    t.index ["public"], name: "index_organizations_on_public", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.text     "permissions", default: "{}", null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "uid"
    t.string   "image_url"
    t.string   "social_id"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["uid"], name: "index_users_on_uid", unique: true, using: :btree
  end

end
