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

ActiveRecord::Schema.define(version: 20140508115336) do

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

end
