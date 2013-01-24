class PhotoController < ApplicationController
  before_filter :login_required, :only => [ 'edit', 'new', 'create', 'destroy' ]
  layout "standard", :except => :flickr
  require 'flick'

  def new
    @photo = Photo.new
    @photo.date = params[:date]
    @userplace = Userplace.find(params[:userplace_id])
    @photo.userplace_id = @userplace.id
  end

  def create
    @photo = Photo.new(params[:photo])
    @userplace = Userplace.find(@photo.userplace_id)
    if @photo.save
      flash[:notice] = 'Photo was successfully added.'
      redirect_to :controller=> 'userplace', :action => 'show', :id => @userplace, :date => @photo.date
    else
      render :action => 'new'
    end
  end

  def edit
    @photo = Photo.find(params[:id])
    @userplace = Userplace.find(@photo.userplace_id)
  end

  def update
    @photo = Photo.find(params[:id])
    @userplace = Userplace.find(@photo.userplace_id)
    if @photo.update_attributes(params[:photo])
      flash[:notice] = 'Photo was successfully updated.'
      redirect_to :controller=> 'userplace', :action => 'show', :id => @userplace, :date => @photo.date
    else
      render :action => 'edit'
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    photodate = @photo.date
    @userplace = Userplace.find(@photo.userplace_id)
    @photo.destroy
    render :nothing => true
  end

  def flickr
      keyword = params[:keyword]
      flickr = Flickr.new
      userpref = Userpref.find_by_user_id(@session[:user].id)
      user = flickr.users(userpref.flickr_name)
      @photos = user.tag(keyword)
  end


end
