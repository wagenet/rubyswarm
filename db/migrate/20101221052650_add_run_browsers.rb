class AddRunBrowsers < ActiveRecord::Migration
  def self.up
    add_column :runs, :browsers, :string
  end

  def self.down
    remove_column :runs, :browsers, :string
  end
end
