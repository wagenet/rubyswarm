class CreateUseragentRuns < ActiveRecord::Migration
  def self.up
    create_table :useragent_runs do |t|
      t.integer :run_id
      t.integer :useragent_id
      t.integer :runs, :default => 0
      t.integer :max
      t.integer :completed
      t.integer :status

      t.timestamps
    end

    add_index :useragent_runs, :run_id
    add_index :useragent_runs, :useragent_id
  end

  def self.down
    drop_table :useragent_runs
  end
end
