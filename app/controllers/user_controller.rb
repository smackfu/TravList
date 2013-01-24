class UserController < ApplicationController
    before_filter :login_required, :only => [ 'destroy', 'export', 'csv' ]
    before_filter :admin_required, :only => [ 'destroy' ]
    layout "standard", :except => [:rss, :csv, :export, :day]
    caches_page :rss

    def show
      begin
        @user = User.find(params[:id], :include=>:userpref)
      rescue ActiveRecord::RecordNotFound
        @user = User.find_by_login(params[:id])
        if @user.nil?
          redirect_to :controller=> 'meta', :action => 'index'
          return
        end
      end
    end

    def blog
      @user = User.find(params[:id])
    end
    
    def journal
      @user = User.find(params[:id])
      render :action => "blog"
    end

    def list
     @users = User.find(:all, :order=>'created_at')
    end

    def calendar
      @user = User.find(params[:id])
      if params[:year]
        @year = params[:year].to_i
      else
        if Time.now.month > 3
          @year = Time.now.year
        else
          @year = Time.now.year - 1
        end
      end
      
      @userplaces = Userplace.find(:all, :include => [:trip], :conditions => ["trips.user_id = ? and year(start_date) = ?", params[:id], @year], :order => "start_date desc, dayorder desc")
      @cal = Array.new
      if @userplaces.size > 0
        for userplace in @userplaces
           if userplace.end_date
             userplace.start_date.upto(userplace.end_date) do |date|
               if date.year == @year
                 @cal[date.yday] = userplace.id;
               end
             end
           else
            @cal[userplace.start_date.yday] = userplace.id;
           end
        end
      end
    end

    def day
      @user = User.find(params[:id])
      date = Date::ordinal(params[:year].to_i,params[:day].to_i) 
      @userplaces = Userplace.find(:all, :include => [:trip,:place], :conditions => ["trips.user_id = ? and (start_date = ? or (start_date < ? and end_date >= ?))", params[:id], date, date, date], :order => "dayorder desc")
      #if @userplaces.size == 1
      #  redirect_to :controller => 'userplace', :action => 'show', :id => @userplaces[0]
      #els
      #if @userplaces.size == 0
      #  redirect_to :action => 'calendar', :year => params[:year], :id => params[:id]
      #end
      
    end

    def with
      @user = User.find(params[:id])
      @name = params[:name]
    end
    
    def tag
      @user = User.find(params[:id])
      @tagname = params[:name]
      @tagplaces = @user.userplaces_with_tag(@tagname)
    end
    
    def tagmap
      @user = User.find(params[:id])
      @tagname = params[:name]
      @tagplaces = @user.userplaces_with_tag(@tagname)

      @errors = Array.new 
      @mapplaces = Array.new

      for userplace in @tagplaces
        if userplace.place.lat == 0
          @errors.push userplace.place
        else  
          @mapplaces.push userplace
        end
      end    
    end

    def scorecard

      @user = User.find(params[:id])
      @userpref = Userpref.find_by_user_id(@user.id)

      @countries = Country.find_by_sql("SELECT distinct countries.* from trips, userplaces, places, countries where trips.id = userplaces.trip_id and userplaces.place_id = places.id and places.country_id=countries.id and trips.id != #{@userpref.wishlist_trip_id} and trips.user_id = #{params[:id]} order by countries.name")    

      @countrystring = ""
      for country in @countries
         @countrystring+=country.isocode
      end

      @continents = Continent.find_by_sql("SELECT distinct continents.* from trips, userplaces, places, countries,continents where trips.id = userplaces.trip_id and userplaces.place_id = places.id and places.country_id=countries.id and countries.continent_id = continents.id and  trips.id != #{@userpref.wishlist_trip_id} and trips.user_id = #{params[:id]} order by countries.name")    

      @allcountries = Country.find_all
      @allcontinents = Continent.find_all

    end

    def map
      @user = User.find(params[:id])
      @userpref = Userpref.find_by_user_id(@user.id)
      @alluserplaces = Userplace.find(:all, :include => [:trip,:place], :conditions => ["trips.user_id = ? and userplaces.trip_id != ?", params[:id], @userpref.wishlist_trip_id], :order => "userplaces.id desc")

      @errors = Array.new 
      @userplaces = Array.new

      for userplace in @alluserplaces
        if userplace.place.lat == 0
          @errors.push userplace.place
        else  
          @userplaces.push userplace
        end
     end
      
    end

    def rss
      @user = User.find(params[:id])
      @userplaces = Userplace.find(:all, :include => [:trip,:place], :conditions => ["trips.user_id = ?", params[:id]], :order => "userplaces.updated_at desc, userplaces.id desc", :limit => 15)
    end

  def destroy
    user = User.find(params[:id])
    #user.destroy
    redirect_to :controller => 'meta', :action=>'index'
  end

  def csv 
      @user = User.find(params[:id])
      @trips = Trip.find(:all, :conditions => ["user_id = ? and fake = false", @user.id], :order => "start desc")
      @userplaces = Userplace.find(:all, :include => [:trip,:place], :conditions => ["trips.user_id = ?", @user.id], :order => "userplaces.id desc")
  end

  def export
    @user = User.find(params[:id])
    if @session[:user] == @user
        @headers['Content-Type'] = 'text/xml; charset=utf-8'
        @trips = Trip.find(:all, :conditions => ["user_id = ? and fake = false", @user.id], :include => [:userplaces], :order => "start desc")
        @fakeplaces = Userplace.find(:all, :include => [:trip,:place], :conditions => ["trips.user_id = ? and trips.fake = true", @user.id], :order => "userplaces.id desc")
    else
      redirect_to :controller => 'user', :action=>'show', :id=>@user
    end
  end
end
