class RenameCmsCopiesType < ActiveRecord::Migration
  def self.up
    rename_column :cms_copies, :type, :case
  end

  def self.down
    rename_column :cms_copies, :case, :type
  end
end
