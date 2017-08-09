class CreateItems < ActiveRecord::Migration[5.1]
  def change
    create_table :items do |t|
      t.string :wordnet_id
      t.string :file_path
      t.integer :source_id, :limit => 1
      t.integer :item_type, :limit => 1
      t.integer :retried_time, :limit => 1
      t.integer :item_status, :limit => 1

      t.timestamps
    end
    #change_column :items, :id, :integer, :limit => 4
  end
end
