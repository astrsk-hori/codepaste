class RemoveFalseToPages < ActiveRecord::Migration
  def change
    remove_column :pages, :false, :text
  end
end
