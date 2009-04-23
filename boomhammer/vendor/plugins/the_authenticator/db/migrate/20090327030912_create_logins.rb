class CreateLogins < ActiveRecord::Migration
  def self.up
    create_table :logins do |t|
      t.references :account, :null => false
      t.string :identity_url, :null => false

      t.timestamps :null => false
    end

    add_index :logins, :identity_url, :unique => true
  end

  def self.down
    drop_table :logins
  end
end
