class AddCopyToCmsTables < ActiveRecord::Migration
  def self.up
    add_column :cms_links, :copy, :integer, array: true, null:false, default: '{}'
    add_column :cms_components, :copy, :integer, array: true, null:false, default: '{}'
    add_column :cms_pages, :copy_from, :integer
    add_column :cms_links, :copy_from, :integer
    add_column :cms_components, :copy_from, :integer
  end

  def self.down
    remove_column :cms_links, :copy
    remove_column :cms_components, :copy
    remove_column :cms_pages, :copy_from
    remove_column :cms_links, :copy_from
    remove_column :cms_components, :copy_from
  end
end
