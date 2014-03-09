class AddMetaData < ActiveRecord::Migration
  def up
    add_column :cms_pages, :meta_description, :text
    add_column :cms_pages, :meta_keywords, :text
  end

  def down
    remove_column :cms_pages, :meta_keywords
    remove_column :cms_pages, :meta_description
  end
end
