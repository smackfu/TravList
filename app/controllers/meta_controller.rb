class MetaController < ApplicationController
   layout "standard"

   def index
      store_location
      if @session[:user]
        @user = User.find(@session[:user].id)
        #@trips = Trip.find(:all, :conditions => ["user_id = ? and fake = false", @user.id], :order => "start desc")
      else
        #@trips = Trip.find(:all, :conditions => "fake = false", :order=>'id desc')
      end
      @userplaces = Userplace.find(:all, :order=>'id desc', :limit=>5);
      @photos = Photo.find(:all, :conditions => ["flickr_img != '' and private = false"], :order =>'rand()', :limit => 5)
      @top_places = Place.find_by_sql(["select places.id, places.name, places.country_id, count(distinct(trips.user_id)) as count from places left outer join userplaces on places.id = userplaces.place_id left outer join trips on userplaces.trip_id = trips.id group by places.id order by 4 desc limit 5" ])

      @systemnotes =  Systemnote.find(:all, :conditions=>'start_date <= now() and end_date >= now()', :order=>'start_date desc')

   end

   def login
      render :action => "index"
   end

   def world
      @continents = Continent.find_by_sql("select continents.id, continents.name, count(places.id) as count from continents join countries on countries.continent_id = continents.id left outer join places on countries.id = places.country_id group by continents.id order by 3 desc")
      # country count
      #@continents = Continent.find_by_sql("select continents.id, continents.name, count(*) as count from continents, countries where countries.continent_id = continents.id group by continents.id order by 3 desc")

   end

  def welcome
      @user = User.find(@session[:user].id)
      @userpref = Userpref.find_by_user_id(@user.id)
  end

   def color
      cookies[:color] =  { :value=>params[:id], :expires => Time.now + ( 365 * (60*60*24))}
      redirect_to @request.env['HTTP_REFERER'] if @request.env['HTTP_REFERER'] 
   end

end
