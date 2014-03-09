class CreateCmsUsers < ActiveRecord::Migration
  def change
    create_table :cms_users do |t|
      t.string :email
      t.string :name
      t.string :password_digest

      t.timestamps
    end
    add_index :cms_users, :email, unique: true
  end
end
