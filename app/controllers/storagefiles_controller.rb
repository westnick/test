class StoragefilesController < ApplicationController
  before_filter :require_authentication, :only=>[:index,:show,:show_all,:show_public]
  def new
    @user = User.find(params[:user_id])
  end
  def uploadFile
    @user = User.find(params[:user_id])
    name =  params[:upload]['datafile'].original_filename
    file_ext = File.extname(name)         #=> ".rb"
    arr_types = Array['.doc','.docx','.docm','.dot','.dotx','.dotm','.rtf','.ppt','.pot','.pps']
    if (arr_types.include?(file_ext))
      begin
        directory = "./public/data"
        fpath = File.join(directory, name)
        ftype = params[:upload]['datafile'].content_type
        fsize = params[:upload]['datafile'].size
        c = @user.storagefiles.find_by_name(name)
        c.update_attributes(:name =>name,:path =>fpath,:files_type =>ftype,:size =>fsize,:access =>'private')
      rescue #RecordNotFound
        @user.storagefiles << Storagefile.new(:name=>name, :path=>fpath,:files_type=>ftype,:size=>fsize, :access=>'private')
      end
      # write the file
      File.open(fpath, "wb") { |f| f.write(params[:upload]['datafile'].read) }
      flash[:notice] ="File uploaded successfully "
    else
      flash[:notice] = "Cannot upload file. You can upload only Word & PowerPoint files!"
    end
    redirect_to new_user_storagefile_path(@user)
  end

  def index
    @user = User.find(params[:user_id])
    case params[:ffield]
    when 'files_type','size','name'
      @sfiles = @user.storagefiles.find(:all, :order => "#{params[:ffield]} #{params[:order]}")
    else
      @sfiles = @user.storagefiles.find(:all, :order => "id asc")
    end
    render :action => "index"
  end
  def show_all
    @user = User.find(params[:user_id])
    case params[:ffield]
    when 'files_type','size','name'
      @sfiles = Storagefile.find(:all, :order => "#{params[:ffield]} #{params[:order]}")
    else
      @sfiles = Storagefile.find(:all, :order => "user_id asc")
    end
    render :action => "show_all"
  end
  def show_public
    @user = User.find(params[:user_id])
    pub = 'public'
    case params[:ffield]
    when 'files_type','size','name'
      @sfiles = Storagefile.find(:all, :conditions =>["access = ? AND user_id <> ?", pub, params[:user_id]], :order => "#{params[:ffield]} #{params[:order]}")
    else
      @sfiles = Storagefile.find(:all, :conditions =>["access = ? AND user_id <> ?", pub, params[:user_id]], :order => "user_id asc")
    end
    render :action => "show_public"
  end
  def apply
    if request.post?
      @user = User.find(params[:user_id])
      access_ids = params[:access_id].collect {|id| id.to_i} if params[:access_id]
      delete_ids = params[:deleteFiles].collect {|id| id.to_i} if params[:deleteFiles]
      if access_ids
        flash[:notice] = "Files successfully updated"
        access_ids.each do |id|
          r = @user.storagefiles.find(id)
          if r.access == "public"
            r.access = "private"
          else
            r.access = "public"
          end
          r.save
        end
      end
      if delete_ids
        flash[:notice] = "Files successfully deleted"
        Storagefile.destroy(delete_ids)
      end
      flash[:notice] = "Files successfully updated and deleted" if access_ids && delete_ids
      flash[:notice] = ""  if !access_ids && !delete_ids
       
    end
    redirect_to user_storagefiles_path(@user)
  end
 
end
