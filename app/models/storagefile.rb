class Storagefile < ActiveRecord::Base
#  belongs_to :user
attr_accessible :user_id, :name, :name, :path, :files_type, :size, :access
#attr_reader :attr_names
#attr_writer :attr_names
  def self.save(upload, user_id)
      name =  upload['datafile'].original_filename
      file_ext = File.extname(name)         #=> ".rb"
      arr_types = Array['.doc','.docx','.docm','.dot','.dotx','.dotm','.rtf','.ppt','.pot','.pps']
      return if !(arr_types.include?(file_ext))
    begin
      directory = "./public/data"
      @path = File.join(directory, name)
      @type =  upload['datafile'].content_type
      @size =  upload['datafile'].size
      c = Storagefile.find_by_name_and_user_id(name, user_id)
      c.update_attributes(:user_id =>user_id,:name => name,:path =>@path,:files_type =>@type,:size =>@size,:access =>'private')
    rescue #RecordNotFound
      @new_file = Storagefile.new do |f|
        f.user_id = user_id
        f.name    = name
        f.path    = @path
        f.files_type= @type
        f.size    = @size
        f.access  = 'private'
        f.save
      end
    end
    # write the file
    File.open(@path, "wb") { |f| f.write(upload['datafile'].read) }
  end
  def self.destroy(delete_ids)
    if delete_ids
      delete_ids.each do |id|
        c = find(id)
        directory = "#{RAILS_ROOT}"
        @path = File.join(directory, c.path)
        c.destroy
        if !(File.directory?("#{@path}"))
          File.delete("#{@path}") if File.exist?("#{@path}")
        end
      end
    end
  end
  
end