class PlaceController < ApplicationController
    before_filter :login_required, :only => [ 'edit', 'new', 'update' ]
    #caches_page :show
    layout "standard"

    def edit
        @place = Place.find(params["id"])
        @countries = Country.find(:all, :order => "name")
        if params[:type] == 'new'
          render :action => 'newish'
        end
    end

    def new
        @place = Place.new
        @countries = Country.find(:all, :order => "name")
    end

  def create
    @place = Place.new(params[:place])
    if @place.save
      flash[:notice] = 'Place was successfully created.'
      redirect_to :action=>'show', :id=>@place
    else
      @countries = Country.find(:all, :order => "name")
      render :action => 'new'
    end
  end


  def destroy
    place = Place.find(params[:id])
    userplaces = Userplace.find_all_by_place_id(place.id)
    if userplaces
      for userplace in userplaces
        userplace.destroy
      end
    end
    country = place.country
    place.destroy
    if country.id != 0
      redirect_to :controller=> 'country', :action => 'show', :id => country
    else 
      redirect_to :controller=> 'meta', :action => 'index'
    end
  end

  def update
      @place = Place.find(params[:id])
      if @place.update_attributes(params[:place])
        flash[:notice] = 'Place was successfully updated.'
        return_to = @session[:return_to]
        if return_to != nil 
           redirect_to return_to
           @session[:return_to] = nil
        else
           redirect_to :action => 'show', :id => @place
        end   
      else
        render :action => 'edit'
      end
    end

    def mostvisited
    end

    def search
      @placequery = params[:placename]
      if @placequery
        if @placequery.size <= 3
          @places =  Array.new
          @tooshort = 'true'
        else
          @places = Place.find_by_sql ["SELECT * FROM places WHERE lower(name) like lower( ? )", params[:placename]+'%']
          @countries = Country.find_by_sql ["SELECT * FROM countries WHERE lower(name) like lower( ? )", params[:placename]+'%']
        end
        if @places.size == 1
             redirect_to :action => 'show', :id => @places[0]
        elsif @countries.size == 1
             redirect_to :controller => 'country', :action => 'show', :id => @countries[0]
        end
      end
    end

    def findbyname
      @places = Place.find_by_sql ["SELECT * FROM places WHERE lower(name) like lower( ? )", params[:name]+'%']
      if @places.size == 0
        render :partial => "country"
      else
        render :partial => "selection"
      end
    end

  def show
    store_location
    @place = Place.find(params[:id])
    @reviewplaces = Userplace.find(:all, :conditions => ["place_id = ? and review != ''", params[:id]])
    average = Userplace.find_by_sql ["select avg(rating) as rating, count(*) as count from userplaces where place_id = ? and rating != 0", params[:id]]
    @rating = 0
    if average[0].rating
       @rating = average[0].rating
       @ratingcount = average[0].count
    end
    @photos = Photo.find_by_sql ["select * from photos left outer join userplaces on photos.userplace_id = userplaces.id where userplaces.place_id = ? and photos.private = false", params[:id]]
    @users = Userplace.find(:all, :include => [:trip],:conditions => ["place_id = ?", params[:id]], :order => "start_date desc", :limit => 10)

  end

  def map
    @place = Place.find(params[:id])
  end
end
