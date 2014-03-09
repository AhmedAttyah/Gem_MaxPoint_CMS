require 'activerecord-postgres-hstore/activerecord'

class CreateCmsLinks < ActiveRecord::Migration
  def change
    create_table :cms_links do |t|
      t.string :name
      t.string :text
      t.integer :parent_id
      t.integer :page_id
      t.string :external_url
      t.integer :locality_id
      t.string :alt
      t.string :target
      t.string :title
      t.text :summary
      t.text :description
      t.integer :position
      t.hstore :data

      t.timestamps
    end
  end
end
