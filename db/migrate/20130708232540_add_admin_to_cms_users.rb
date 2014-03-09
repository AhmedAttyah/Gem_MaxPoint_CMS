class AddAdminToCmsUsers < ActiveRecord::Migration
  def self.up
    add_column :cms_users, :admin, :boolean, default: '0'

    Cms::User.update_all('admin = true')
  end

  def self.down
    remove_column :cms_users, :admin
  end
end
