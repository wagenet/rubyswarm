class CreateClientRuns < ActiveRecord::Migration
  def self.up
    create_table :client_runs do |t|
      t.integer :run_id
      t.integer :client_id
      t.integer :status
      t.integer :fail
      t.integer :error
      t.integer :total
      t.text :results

      t.timestamps
    end

    add_index :client_runs, :run_id
    add_index :client_runs, :client_id
  end

  def self.down
    drop_table :client_runs
  end
end
