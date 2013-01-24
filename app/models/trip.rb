class Trip < ActiveRecord::Base
    belongs_to :user
    has_many :userplace, :dependent => true

    validates_presence_of :name

    def allphotos
      photos = Array.new
      userplace.each do |place|
        photos += (place.photo)
      end
      return photos
    end
    
end
