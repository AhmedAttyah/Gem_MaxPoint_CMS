class AddKindToPages < ActiveRecord::Migration
  def up
    add_column :cms_pages, :type, :string
    add_column :cms_posts, :meta_keywords, :text
    remove_column :cms_posts, :meta_title
  end

  def down
    add_column :cms_posts, :meta_title, :string
    remove_column :cms_posts, :meta_keywords
    remove_column :cms_pages, :type
  end
end
