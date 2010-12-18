class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :user_id
      t.string :name
      t.integer :status

      t.timestamps
    end

    add_index :jobs, :user_id
  end

  def self.down
    drop_table :jobs
  end
end
