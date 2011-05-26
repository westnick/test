class Storagefile < ActiveRecord::Base
  belongs_to :user, :foreign_key => "user_id"
  attr_accessible :name, :path, :files_type, :size, :access
  #attr_reader :attr_names
  #attr_writer :attr_names
 def self.destroy(delete_ids)
    if delete_ids
      delete_ids.each do |id|
        c = Storagefile.find(id)
        directory = "#{RAILS_ROOT}"
        fpath = File.join(directory, c.path)
        c.destroy
        if !(File.directory?("#{fpath}"))
          File.delete("#{fpath}") if File.exist?("#{fpath}")
        end
      end
    end
  end
  
end