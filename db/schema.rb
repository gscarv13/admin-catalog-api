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

ActiveRecord::Schema[7.1].define(version: 2024_05_01_185940) do
  create_table "audio_video_media", id: :string, force: :cascade do |t|
    t.string "video_id"
    t.string "name"
    t.string "raw_location"
    t.string "encoded_location"
    t.integer "status"
    t.integer "medium_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["video_id"], name: "index_audio_video_media_on_video_id"
  end

  create_table "cast_members", id: :string, force: :cascade do |t|
    t.string "name"
    t.integer "role_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cast_members_videos", id: false, force: :cascade do |t|
    t.string "cast_member_id"
    t.string "video_id"
  end

  create_table "categories", id: :string, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_categories_on_id", unique: true
  end

  create_table "categories_genres", id: false, force: :cascade do |t|
    t.string "genre_id"
    t.string "category_id"
  end

  create_table "categories_videos", id: false, force: :cascade do |t|
    t.string "category_id"
    t.string "video_id"
  end

  create_table "genres", id: :string, force: :cascade do |t|
    t.string "name"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_genres_on_id", unique: true
  end

  create_table "genres_videos", id: false, force: :cascade do |t|
    t.string "genre_id"
    t.string "video_id"
  end

  create_table "videos", id: :string, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "launch_year"
    t.string "duration"
    t.boolean "published"
    t.integer "rating", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
