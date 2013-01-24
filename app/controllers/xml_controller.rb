class XmlController < ApplicationController

def sitemap
  @headers['Content-Type'] = 'text/xml; charset=utf-8'
  @countries = Country.find_all
  @places = Place.find_all
  @trips = Trip.find_all
  @users = User.find_all
  @userplaces = Userplace.find_all
end

end
