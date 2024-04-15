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

ActiveRecord::Schema[7.1].define(version: 2024_04_13_234734) do
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

  create_table "genres", id: :string, force: :cascade do |t|
    t.string "name"
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_genres_on_id", unique: true
  end

end
