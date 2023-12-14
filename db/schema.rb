# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_12_14_085359) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "change_logs", force: :cascade do |t|
    t.jsonb "data", default: {}, null: false
    t.string "changeable_type", null: false
    t.bigint "changeable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["changeable_type", "changeable_id"], name: "index_change_logs_on_changeable"
    t.index ["user_id"], name: "index_change_logs_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id"], name: "index_likes_on_record"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "product_category"
    t.bigint "place_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price"
    t.boolean "approved", default: false
    t.integer "likes_count", default: 0
    t.boolean "active", default: true
    t.bigint "creator_id"
    t.index ["creator_id"], name: "index_menus_on_creator_id"
    t.index ["place_id"], name: "index_menus_on_place_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "longitude"
    t.float "latitude"
    t.text "address"
    t.boolean "vegan"
    t.string "instagram_url"
    t.string "facebook_url"
    t.string "twitter_url"
    t.string "web_url"
    t.string "email"
    t.string "phone"
    t.boolean "approved", default: false
    t.integer "contributors", default: [], array: true
  end

  create_table "places_tags", id: false, force: :cascade do |t|
    t.bigint "place_id", null: false
    t.bigint "tag_id", null: false
    t.index ["place_id", "tag_id"], name: "index_places_tags_on_place_id_and_tag_id"
    t.index ["tag_id", "place_id"], name: "index_places_tags_on_tag_id_and_place_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "rating"
    t.text "content", null: false
    t.text "feedback"
    t.boolean "approved", default: false
    t.bigint "place_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_reviews_on_place_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean "approved", default: false
    t.integer "role", default: 0
    t.integer "points", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "change_logs", "users"
  add_foreign_key "likes", "users"
  add_foreign_key "menus", "places"
  add_foreign_key "menus", "users", column: "creator_id"
  add_foreign_key "reviews", "places"
  add_foreign_key "reviews", "users"
end
