class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :url, limit: 2048
      t.text :cache_text
      t.text :cache_image

      t.timestamps null: false
    end
  end
end
