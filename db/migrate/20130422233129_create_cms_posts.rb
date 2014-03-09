class CreateCmsPosts < ActiveRecord::Migration
  def change
    create_table :cms_posts do |t|
      t.integer :locality_id
      t.integer :author_id
      t.string :slug
      t.string :title
      t.text :description
      t.text :body
      t.boolean :published
      t.datetime :published_at
      t.string :meta_title
      t.text :meta_description

      t.timestamps
    end
  end
end
