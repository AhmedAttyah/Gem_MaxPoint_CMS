class CreateCmsCopies < ActiveRecord::Migration
  def change
    create_table :cms_copies do |t|
      t.string :type
      t.integer :locality_from
      t.integer :locality_to
      t.integer :id_from
      t.integer :id_to

      t.timestamps
    end
  end
end
