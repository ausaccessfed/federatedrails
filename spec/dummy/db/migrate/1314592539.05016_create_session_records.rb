class CreateSessionRecords < ActiveRecord::Migration
  def self.up
    create_table :session_records do |t|
      t.string :credential
      t.string :remote_host
      t.string :user_agent
      t.references :subject

      t.timestamps
    end
  end

  def self.down
    drop_table :session_records
  end
end
