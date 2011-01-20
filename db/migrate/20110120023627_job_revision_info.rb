class JobRevisionInfo < ActiveRecord::Migration
  def self.up
    add_column :jobs, :url, :string
    add_column :jobs, :revision, :string
    add_column :jobs, :test_creation_date, :datetime
    Job.update_all("test_creation_date = created_at")
  end

  def self.down
    remove_column :jobs, :url
    remove_column :jobs, :revision
    remove_column :jobs, :test_creation_date
  end
end
