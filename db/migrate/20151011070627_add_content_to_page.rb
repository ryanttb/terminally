class AddContentToPage < ActiveRecord::Migration
  def change
    add_column :pages, :content, :text
  end
end
