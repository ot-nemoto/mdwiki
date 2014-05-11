class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents, :id => false do |t|
      t.string :content_id, null: false
      t.string :parent_id, null: false
      t.string :subject
      t.text :content
      t.string :created_user
      t.datetime :created_at
      t.string :updated_user
      t.datetime :updated_at
      t.boolean :deleted, null: false, default: false

    end
    add_index :contents, :content_id, unique: true
  end
end
