class Userpref < ActiveRecord::Base
 belongs_to :user

 def before_create

   @trip = Trip.new
   @trip.name = "Wishlist"
   @trip.fake = true
   @trip.user_id = self.user_id
   @trip.save
   self.wishlist_trip_id = @trip.id

   @trip = Trip.new
   @trip.name = "Not on a trip"
   @trip.fake = true
   @trip.user_id = self.user_id
   @trip.save
   self.notrip_trip_id  = @trip.id

 end
end
