class CreateCmsCategories < ActiveRecord::Migration
  def change
    create_table :cms_categories do |t|
      t.string :name
      t.integer :locality_id

      t.timestamps
    end
  end
end
