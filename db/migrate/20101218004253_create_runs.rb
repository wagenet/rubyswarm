class CreateRuns < ActiveRecord::Migration
  def self.up
    create_table :runs do |t|
      t.integer :job_id
      t.string :name
      t.text :url
      t.integer :status

      t.timestamps
    end

    add_index :runs, :job_id
  end

  def self.down
    drop_table :runs
  end
end
