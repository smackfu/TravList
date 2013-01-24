class UserplaceController < ApplicationController
    before_filter :login_required, :except => [ 'show', 'list', 'listuser' ]
    layout "standard", :except => [ 'editdate', 'edittags' ]
    scaffold :userplace
    require 'flick'

    def list
    end

    def edit
       @userplace = Userplace.find(params[:id])
       @trips = Trip.find(:all, :conditions => ["user_id = ?", @session[:user].id], :order => 'fake, name')
       if @session[:user] != @userplace.trip.user
         redirect_to :action => 'show', :id => @userplace
       end

    end

    def listuser
#        @userplace_pages, @userplaces = paginate :userplaces, :conditions => ["trips.user_id = ? and trip_id = trips.id",params[:user]],:per_page => 20,:include => [:trip]
        @userplaces = Userplace.find(:all, :conditions => ["trips.user_id = ? and trip_id = trips.id",params[:user]],:include => [:trip], :order => 'start_date desc')
        @user = User.find(params[:user])
    end

    def new
       @newflag = true;
       @userplace = Userplace.new
       @userplace.review = ''
       @trips = Trip.find(:all, :conditions => ["user_id = ?", @session[:user].id], :order => 'fake, name')
       if params[:trip_id]
         @userplace.trip = Trip.find(params[:trip_id])
         if @userplace.trip.user != @session[:user]
           redirect_to :controller=>'trip', :action => 'show', :id => @userplace.trip
         end
       end
       if params[:date]
         @userplace.start_date = params[:date]
       else
         #@userplace.start_date = 1;
       end
       if params[:placename]
         @initplace = params[:placename]
       end
       if !@userplace.trip
         #redirect_to :controller=>'user', :action => 'show', :id => @session[:user]
       end
    end

  def assign_place(placename)
    #check if place exists
    places = Place.find_all_by_name(placename)
    
    #use first result
    if places.length > 0
      return places[0]
    else
      if /,\s\w\w\Z/ =~ placename
        newplace = Place.new
        newplace.name = placename
        newplace.country = Country.find_by_name('United States')
        newplace.save
        return newplace
      end
    end
    return nil
  end

  def update
    @userplace = Userplace.find(params[:id])
    expire_userplace(@userplace)

    @userplace.attributes = params[:userplace]

    if params[:placename]
      @userplace.place = assign_place(params[:placename])
    end
   
    if  @userplace.place
      if @userplace.save
        flash[:notice] = 'Stop was successfully updated.'
        redirect_to :action => 'show', :id => @userplace
      else
        render :action => 'edit'
      end
    else      
      @session[:placename] = params[:placename]
      @session[:userplace] = @userplace
      redirect_to :action => 'newplace'
    end    
    
  end

  def create
    @userplace = Userplace.new(params[:userplace])
    @userplace.place = assign_place(params[:placename])
    @userplace.review = ''
    
    if @userplace.place
      if @userplace.save
        flash[:notice] = 'Stop was successfully created.'
        redirect_to :action => 'show', :id => @userplace
      else
        render :action => 'new'
      end
    else      
      @session[:placename] = params[:placename]
      @session[:userplace] = @userplace
      redirect_to :action => 'newplace'
    end
  end

  def createplace
    @newplace = Place.new(params[:place])
    @newplace.save
    
    @userplace = @session[:userplace]
    @userplace.place = @newplace    

    if @userplace.save
      @session[:userplace] = nil
      @session[:placename] = nil
      flash[:notice] = 'Stop was successfully created.'
      redirect_to :action => 'show', :id => @userplace
    else
      render :action => 'new'
    end

  end

  def destroy
    userplace = Userplace.find(params[:id])
    expire_userplace(userplace)
    if @session[:user] != userplace.trip.user
       redirect_to :action => 'show', :id => userplace and return
    end
    trip = userplace.trip
    userplace.destroy
    #redirect_to @request.env['HTTP_REFERER']
    if !trip.fake
      redirect_to :controller => 'trip', :action=>'show',:id=>trip
    else
      redirect_to :controller => 'user', :action=>'show', :id => @session[:user].id
    end
  end

  def show
    @userplace = Userplace.find(params[:id],:include => [:trip, {:place=>:country}, {:daynote=>[:notetype,:userplace]}, :photo])
    @displaydate = Date.parse(params[:date]) if params[:date]
#    @daynotes = @alldaynotes = Daynote.find_all_by_userplace_id(@userplace.id, :order => 'date')
#    @photos = @allphotos = Photo.find_all_by_userplace_id(@userplace.id, :order => 'date')
#    @movies = Movie.find_all_by_userplace_id(@userplace.id, :order => 'date')
#    if (@displaydate)
#      @daynotes = Daynote.find_all_by_date_and_userplace_id(@displaydate,@userplace.id)
#      @photos = Photo.find_all_by_date_and_userplace_id(@displaydate,@userplace.id)
#    end
  end

  def expire_userplace(userplace)
    expire_fragment :controller=>'trip', :action=>'show', :id=>userplace.trip
    expire_fragment :action=>'show', :id=>userplace
    expire_page :controller=>'user', :action=>'rss', :id=>userplace.trip.user
    expire_page :controller=>'trip', :action=>'rss', :id=>userplace.trip
  end

  def rating
    @userplace = Userplace.find(params[:id])
    @userplace.rating = params[:rating]
    @userplace.save
    render_partial 'rating'
  end

  def editdate
    @userplace = Userplace.find(params[:id])
  end
  
  def updatedate
    @userplace = Userplace.find(params[:id])
    if @userplace.update_attributes(params[:userplace])
      render :partial => 'date'
    end
  end

  def edittags
    @userplace = Userplace.find(params[:id])
  end
  
  def updatetags
    @userplace = Userplace.find(params[:id])
    @userplace.tag params[:tags], :clear=>true
    render :partial => 'tags'
  end


end
