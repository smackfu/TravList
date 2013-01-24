class ContinentController < ApplicationController
    layout "standard"

    def show
        @continent = Continent.find(@params["id"])
        @countries = Country.find_by_sql(["select countries.id, countries.name, count(*) as count from countries, places where places.country_id = countries.id and countries.continent_id = ? group by countries.id order by 3 desc limit 10", @continent.id ])

        if @countries.size == 0
          redirect_to :action=>'showall', :id=>@continent
        end
    end 

    def showall
        @continent = Continent.find(@params["id"])
        @countries = Country.find_by_sql(["select countries.id, countries.name, count(places.country_id) as count from countries left outer join places on places.country_id = countries.id where countries.continent_id = ? group by countries.id order by 3 desc,2", @continent.id ])
    end 
    
end
