class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      t.integer :user_id
      t.integer :useragent_id
      t.string :os
      t.text :useragentstr
      t.string :ip
      t.boolean :active

      t.timestamps
    end

    add_index :clients, :user_id
    add_index :clients, :useragent_id
  end

  def self.down
    drop_table :clients
  end
end
