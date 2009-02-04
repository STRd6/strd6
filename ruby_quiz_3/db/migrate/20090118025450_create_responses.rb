class CreateResponses < ActiveRecord::Migration
  def self.up
    create_table :responses do |t|
      t.references :quiz
      t.string :author
      t.text :body
      t.text :reference

      t.timestamps
    end
  end

  def self.down
    drop_table :responses
  end
end
