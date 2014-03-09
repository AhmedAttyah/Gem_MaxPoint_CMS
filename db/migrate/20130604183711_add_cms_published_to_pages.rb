class AddCmsPublishedToPages < ActiveRecord::Migration
  def self.up
    add_column :cms_pages, :published, :boolean, default: '1'

    Cms::Page.update_all('published=true')
  end
  def self.down
    remove_column :cms_pages, :published
  end
end
