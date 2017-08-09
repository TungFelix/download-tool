class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.integer :session_id
      t.integer :item_id
      t.integer :task_status, :limit => 1

      t.timestamps
    end
    #change_column :tasks, :id, :integer, :limit => 4
  end
end
