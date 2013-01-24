class CountryController < ApplicationController
    before_filter :login_required, :only => [ 'edit', 'new', 'update', 'list', 'destroy' ]
    layout "standard"
    scaffold :country

    def edit
        @country = Country.find(params["id"])
        @continents = Continent.find_all
    end

    def new
        @country = Country.new
        @continents = Continent.find_all
    end

    def show
        if ( 0 == params["id"] )
          redirect_to :controller=>'meta', :action=>'index'
        end
        @country = Country.find(params["id"])
        @places = Place.find_by_sql(["select places.id, places.name, count(userplaces.id) as count from places left outer join userplaces on places.id = userplaces.place_id where places.country_id = ? group by places.id order by 3 desc limit 10", @country.id ])
    end 

    def top
        @countries = Country.find_by_sql("SELECT c.id, c.name, count(*) as count FROM countries c, places p, userplaces u where c.id = p.country_id and p.id = u.place_id group by c.id order by 3 desc")
    end

    def map
      @country = Country.find(params["id"])
      @allplaces = Place.find_all_by_country_id(@country.id)

     @maxlat = -999; @maxlong = -999;
     @minlat = 999; @minlong = 999;
     @errors = Array.new 
     @places = Array.new

     for place in @allplaces
        if place.lat == 0
           @errors.push place
        else
           @maxlat = place.lat if place.lat > @maxlat
           @minlat = place.lat if place.lat < @minlat
           @maxlong = place.long if place.long > @maxlong
           @minlong = place.long if place.long < @minlong
           @places.push place
        end
     end
      
    end
    
end
