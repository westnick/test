class StoragefilesController < ApplicationController
  before_filter :require_authentication, :only=>[:index,:show,:show_all,:show_public]
  def index
    render :action => "index", :id => params[:id]
  end
  def uploadFile
#    arr_types = Array['.doc','.docx','.docm','.dot','.dotx','.dotm','.rtf','.ppt','.pot','.pps']
    @post = Storagefile.save(params[:upload],session[:id])
    if @post
      flash[:notice] ="File uploaded successfully"
    else
      flash[:notice] = "Cannot upload file. You can upload only Word & PPoint files!"
    end
    redirect_to storagefiles_path(:id =>session[:id])
  end

  def show
    case params[:ffield]
    when 'files_type','size','name'
      @sfiles = Storagefile.find_all_by_user_id(session[:id], :order => "#{params[:ffield]} #{params[:order]}")
    else
      @sfiles = Storagefile.find_all_by_user_id(session[:id], :order => "id asc")
    end
    render :template => "./storagefiles/show"
  end
  def show_all
    case params[:ffield]
    when 'files_type','size','name'
      @sfiles = Storagefile.find(:all, :order => "#{params[:ffield]} #{params[:order]}")
    else
      @sfiles = Storagefile.find(:all, :order => "user_id asc")
    end
    render :template => "./storagefiles/show_all"
  end
  def show_public
    pub = 'public'
    case params[:ffield]
    when 'files_type','size','name'
      @sfiles = Storagefile.find(:all, :conditions =>["access = ? AND user_id <> ?", pub, session[:id]], :order => "#{params[:ffield]} #{params[:order]}")
    else
      @sfiles = Storagefile.find(:all, :conditions =>["access = ? AND user_id <> ?", pub, session[:id]], :order => "user_id asc")
    end
    render :template => "./storagefiles/show_public"
  end
  def apply
    if request.post?
      access_ids = params[:access_id].collect {|id| id.to_i} if params[:access_id]
      delete_ids = params[:deleteFiles].collect {|id| id.to_i} if params[:deleteFiles]
      if access_ids
        flash[:notice] = "Files successfully updated"
        access_ids.each do |id|
          r = Storagefile.find_by_id_and_user_id(id,session[:id])
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
    redirect_to storagefile_path(@user)
  end
 
end
