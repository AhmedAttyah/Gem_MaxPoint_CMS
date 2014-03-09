require 'activerecord-postgres-hstore/activerecord'

class CreateCmsComponents < ActiveRecord::Migration
  def up
    execute "CREATE EXTENSION IF NOT EXISTS hstore;" if Rails.env.development? || 
      Rails.env.test?
    create_table :cms_components do |t|
      t.integer :page_id
      t.integer :parent_id
      t.integer :position
      t.string :type
      t.hstore :data
      t.hstore :subcomponents

      t.timestamps
    end
  end
  def down
    drop_table :cms_components
  end
end
