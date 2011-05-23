class RenColumnStoragefile < ActiveRecord::Migration
  def self.up
    rename_column :storagefiles, :type, :files_type
  end

  def self.down
    rename_column :storagefiles, :files_type, :type
  end
end
