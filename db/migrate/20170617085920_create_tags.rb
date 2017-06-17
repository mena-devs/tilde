# This migration is based on: acts_as_taggable_on
class CreateTags < ActiveRecord::Migration[5.0]
  def change
    create_table "tags", force: :cascade do |t|
      t.string  "name"
      t.boolean "is_approved",    default: false
      t.integer "taggings_count", default: 0
      t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
    end
  end
end
