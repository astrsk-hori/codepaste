class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title, null: false
      t.text :body, false
      t.string :tag
      t.string :user_name

      t.timestamps
    end
  end
end
