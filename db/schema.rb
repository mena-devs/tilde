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

ActiveRecord::Schema.define(version: 20200216191717) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "api_keys", force: :cascade do |t|
    t.string "access_token"
    t.integer "user_id"
    t.boolean "enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "invitations", force: :cascade do |t|
    t.integer "user_id"
    t.string "invitee_name"
    t.string "invitee_email"
    t.string "invitee_title"
    t.string "invitee_company"
    t.string "invitee_location"
    t.text "invitee_introduction"
    t.boolean "delivered", default: false
    t.boolean "registered", default: false
    t.boolean "code_of_conduct", default: false
    t.boolean "member_application", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slack_uid"
    t.string "medium"
    t.string "aasm_state"
    t.integer "retries", default: 0
    t.index ["user_id"], name: "index_invitations_on_user_id"
  end

  create_table "job_statistics", force: :cascade do |t|
    t.integer "job_id"
    t.integer "user_id"
    t.integer "counter", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_statistics_on_job_id"
    t.index ["user_id"], name: "index_job_statistics_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "aasm_state"
    t.string "title"
    t.text "description"
    t.string "external_link"
    t.string "country"
    t.boolean "remote", default: false
    t.string "custom_identifier"
    t.datetime "posted_on"
    t.datetime "expires_on"
    t.boolean "posted_to_slack", default: false
    t.integer "user_id"
    t.string "company_name"
    t.string "apply_email"
    t.integer "to_salary"
    t.integer "employment_type"
    t.integer "number_of_openings", default: 1
    t.integer "experience"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "from_salary"
    t.string "currency"
    t.string "education"
    t.integer "payment_term"
    t.string "twitter_handle"
    t.string "slug"
    t.boolean "hired", default: false
    t.index ["deleted_at"], name: "index_jobs_on_deleted_at"
    t.index ["slug"], name: "index_jobs_on_slug", unique: true
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "partners", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "external_link"
    t.string "email"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture_file_name"
    t.string "picture_content_type"
    t.integer "picture_file_size"
    t.datetime "picture_updated_at"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "user_id"
    t.string "nickname"
    t.string "location"
    t.boolean "receive_emails", default: false
    t.boolean "receive_job_alerts", default: false
    t.text "biography"
    t.string "avatar_from_slack"
    t.integer "privacy_level", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean "avatar_from_slack_imported", default: false
    t.datetime "avatar_from_slack_updated_at"
    t.string "title"
    t.string "interests"
    t.string "company_name"
    t.string "twitter_handle"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "provider"
    t.string "uid"
    t.string "auth_token"
    t.string "first_name"
    t.string "last_name"
    t.string "time_zone"
    t.boolean "admin", default: false
    t.string "custom_identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.string "email_reminders"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["custom_identifier"], name: "index_users_on_custom_identifier", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["provider"], name: "index_users_on_provider"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid"], name: "index_users_on_uid"
  end

  add_foreign_key "api_keys", "users"
  add_foreign_key "invitations", "users"
  add_foreign_key "job_statistics", "jobs"
  add_foreign_key "job_statistics", "users"
  add_foreign_key "jobs", "users"
  add_foreign_key "profiles", "users"
end
