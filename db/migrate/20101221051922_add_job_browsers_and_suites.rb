class AddJobBrowsersAndSuites < ActiveRecord::Migration
  def self.up
    add_column :jobs, :browsers, :string
    add_column :jobs, :suites, :text
  end

  def self.down
    remove_column :jobs, :browsers
    remove_column :jobs, :suites
  end
end
