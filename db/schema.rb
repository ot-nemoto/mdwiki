# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140512151401) do

  create_table "attachments", id: false, force: true do |t|
    t.string   "attachment_id",                                  null: false
    t.string   "content_id",                                     null: false
    t.string   "filename",                                       null: false
    t.binary   "attachment",    limit: 16777215
    t.string   "content_type"
    t.string   "updated_user"
    t.datetime "updated_at"
    t.boolean  "deleted",                        default: false, null: false
  end

  add_index "attachments", ["attachment_id"], name: "index_attachments_on_attachment_id", unique: true, using: :btree
  add_index "attachments", ["content_id", "filename"], name: "index_attachments_on_content_id_and_filename", unique: true, using: :btree

  create_table "contents", id: false, force: true do |t|
    t.string   "content_id",                   null: false
    t.string   "parent_id",                    null: false
    t.string   "subject"
    t.text     "content"
    t.string   "created_user"
    t.datetime "created_at"
    t.string   "updated_user"
    t.datetime "updated_at"
    t.boolean  "deleted",      default: false, null: false
  end

  add_index "contents", ["content_id"], name: "index_contents_on_content_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
