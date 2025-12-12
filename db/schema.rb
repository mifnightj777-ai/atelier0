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

ActiveRecord::Schema[7.1].define(version: 2025_12_11_160244) do
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

  create_table "collection_items", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.bigint "fragment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id", "fragment_id"], name: "index_collection_items_on_collection_id_and_fragment_id", unique: true
    t.index ["collection_id"], name: "index_collection_items_on_collection_id"
    t.index ["fragment_id"], name: "index_collection_items_on_fragment_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "visibility", default: 0, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "comparisons", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "fragment_a_id", null: false
    t.bigint "fragment_b_id", null: false
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fragment_a_id", "fragment_b_id"], name: "index_comparisons_on_fragment_a_id_and_fragment_b_id", unique: true
    t.index ["fragment_a_id"], name: "index_comparisons_on_fragment_a_id"
    t.index ["fragment_b_id"], name: "index_comparisons_on_fragment_b_id"
    t.index ["user_id"], name: "index_comparisons_on_user_id"
  end

  create_table "fragment_colors", force: :cascade do |t|
    t.bigint "fragment_id", null: false
    t.string "hex_code"
    t.boolean "is_auto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fragment_id"], name: "index_fragment_colors_on_fragment_id"
  end

  create_table "fragments", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "visibility"
    t.string "title"
    t.bigint "parent_id"
    t.bigint "root_id"
    t.bigint "prompt_id"
    t.index ["parent_id"], name: "index_fragments_on_parent_id"
    t.index ["prompt_id"], name: "index_fragments_on_prompt_id"
    t.index ["root_id"], name: "index_fragments_on_root_id"
    t.index ["user_id"], name: "index_fragments_on_user_id"
  end

  create_table "ideas", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "visibility", default: 1, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_ideas_on_user_id"
  end

  create_table "letters", force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.bigint "fragment_id", null: false
    t.bigint "sender_id", null: false
    t.bigint "recipient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["fragment_id"], name: "index_letters_on_fragment_id"
    t.index ["recipient_id"], name: "index_letters_on_recipient_id"
    t.index ["sender_id"], name: "index_letters_on_sender_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "fragment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fragment_id"], name: "index_likes_on_fragment_id"
    t.index ["user_id", "fragment_id"], name: "index_likes_on_user_id_and_fragment_id", unique: true
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "memos", force: :cascade do |t|
    t.text "content"
    t.bigint "idea_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["idea_id"], name: "index_memos_on_idea_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "user_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "sender_id"
    t.string "action"
    t.string "notifiable_type"
    t.integer "notifiable_id"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "prompts", force: :cascade do |t|
    t.string "content"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.bigint "recipient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "sender_last_read_at"
    t.datetime "recipient_last_read_at"
    t.index ["recipient_id"], name: "index_rooms_on_recipient_id"
    t.index ["sender_id", "recipient_id"], name: "index_rooms_on_sender_id_and_recipient_id", unique: true
    t.index ["sender_id"], name: "index_rooms_on_sender_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "collection_items", "collections"
  add_foreign_key "collection_items", "fragments"
  add_foreign_key "collections", "users"
  add_foreign_key "comparisons", "fragments", column: "fragment_a_id"
  add_foreign_key "comparisons", "fragments", column: "fragment_b_id"
  add_foreign_key "comparisons", "users"
  add_foreign_key "fragment_colors", "fragments"
  add_foreign_key "fragments", "fragments", column: "parent_id"
  add_foreign_key "fragments", "fragments", column: "root_id"
  add_foreign_key "fragments", "prompts"
  add_foreign_key "fragments", "users"
  add_foreign_key "ideas", "users"
  add_foreign_key "letters", "fragments"
  add_foreign_key "letters", "users", column: "recipient_id"
  add_foreign_key "letters", "users", column: "sender_id"
  add_foreign_key "likes", "fragments"
  add_foreign_key "likes", "users"
  add_foreign_key "memos", "ideas"
  add_foreign_key "messages", "rooms"
  add_foreign_key "messages", "users"
  add_foreign_key "rooms", "users", column: "recipient_id"
  add_foreign_key "rooms", "users", column: "sender_id"
end
