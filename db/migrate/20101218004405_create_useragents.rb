class CreateUseragents < ActiveRecord::Migration
  def self.up
    create_table :useragents do |t|
      t.string :name
      t.string :engine
      t.string :version
      t.boolean :active
      t.boolean :current
      t.boolean :popular
      t.boolean :gbs
      t.boolean :beta
      t.boolean :mobile

      t.timestamps
    end
  end

  def self.down
    drop_table :useragents
  end
end
