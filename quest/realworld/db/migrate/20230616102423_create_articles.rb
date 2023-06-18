class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.text :slug
      t.text :title
      t.text :description
      t.text :body

      t.timestamps
    end
  end
end
