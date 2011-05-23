class CreateStoragefiles < ActiveRecord::Migration
  def self.up
    create_table :storagefiles do |t|
      t.integer :user_id
      t.string :name
      t.string :path
      t.string :type
      t.integer :size
      t.string :access
      t.datetime:updated_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :storagefiles
  end
end
