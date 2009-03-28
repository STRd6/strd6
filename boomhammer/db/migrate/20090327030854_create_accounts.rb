class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :nickname
      t.string :email

      t.string :remember_token, :limit => 40
      t.datetime :remember_token_expires_at
      t.string :activation_code, :limit => 40
      t.datetime :activated_at

      t.timestamps :null => false
    end
  end

  def self.down
    drop_table :accounts
  end
end
