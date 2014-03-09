class CreateCmsTags < ActiveRecord::Migration
  def change
    create_table :cms_tags do |t|
      t.string :name
      t.integer :posts_count

      t.timestamps
    end

    create_table :cms_posts_cms_tags, id: false do |t|
      t.integer :post_id
      t.integer :tag_id
    end
  end
end
