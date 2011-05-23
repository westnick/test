module StoragefilesHelper
 def sort_show_url (action_name, name, ffield)
    str = "#{link_to name,:action =>action_name,:ffield =>ffield, :order =>'asc'} " +
          "#{link_to 'asc',:action =>action_name,:ffield =>ffield, :order =>'asc'} "+
          "#{link_to 'desc',:action =>action_name,:ffield =>ffield, :order =>'desc'}"
  end
  def opposite_access_str(file_access)
    if file_access == "public"
      str = "private"
   else
      str = "public"
   end

 end
end
