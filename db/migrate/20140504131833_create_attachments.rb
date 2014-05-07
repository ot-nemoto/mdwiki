class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments, :id => false do |t|
      t.string :attachment_id, null: false
      t.string :content_id, null: false
      t.string :filename, null: false
      t.binary :attachment, :limit => 10.megabyte
      t.string :content_type
      t.string :updated_user
      t.datetime :updated_at
      t.boolean :deleted, null: false, default: false

    end
    add_index :attachments, :attachment_id, unique: true
    add_index :attachments, [:content_id, :filename], unique: true
  end
end
