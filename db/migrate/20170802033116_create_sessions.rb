class CreateSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :sessions do |t|
      t.integer :source_id, :limit => 1
      t.integer :session_status, :limit => 1

      t.timestamps
    end
    #change_column :sessions, :id, :integer, :limit => 4
  end
end
