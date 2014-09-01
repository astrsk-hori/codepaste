class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :user_id, null: false
      t.integer :page_id, null: false
      t.text :comment, null: false

      t.timestamps
    end
    add_index :comments, :page_id, name: :comments_idx1, unique: false
  end
end
