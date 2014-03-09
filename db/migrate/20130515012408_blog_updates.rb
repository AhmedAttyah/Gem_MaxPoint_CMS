class BlogUpdates < ActiveRecord::Migration
  def up
    add_column :cms_comments, :website, :string
    add_column :cms_posts, :category_id, :integer
    add_column :cms_tags, :locality_id, :integer
    add_column :cms_tags, :slug, :string
    add_column :cms_categories, :slug, :string
  end

  def down
    remove_column :cms_categories, :slug
    remove_column :cms_tags, :slug
    remove_column :cms_tags, :locality_id
    remove_column :cms_posts, :category_id
    remove_column :cms_comments, :website
  end
end
