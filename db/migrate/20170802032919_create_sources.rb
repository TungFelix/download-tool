class CreateSources < ActiveRecord::Migration[5.1]
  def change
    create_table :sources do |t|
      t.string :name

      t.timestamps
    end
    #change_column :sources, :id, :integer, :limit => 4
  end
end
