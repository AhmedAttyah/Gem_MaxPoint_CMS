class CreateCmsLocalities < ActiveRecord::Migration
  def change
    create_table :cms_localities do |t|
      t.string :slug
      t.string :name

      t.timestamps
    end
  end
end
