class AddLocalityToCmsComponents < ActiveRecord::Migration
  def self.up
    add_column :cms_compnents, :locality_id, :integer
  end

  def self.down
    remove_column :cms_compnents, :locality_id
  end
end
