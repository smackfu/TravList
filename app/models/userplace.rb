class Userplace < ActiveRecord::Base
    belongs_to :trip
    belongs_to :place
    has_many :daynote, :dependent => true
    has_many :photo, :dependent => true    
    acts_as_taggable

#    validates_presence_of :start_date
#    validates_inclusion_of :start_day, :in => 1..999, :message=>" must be greater than 0"
#    validates_presence_of :placename

     def validate
          #errors.add("end_date", "must be less than a year after start date") if :end_date && :end_date.jd - :start_date.jd > 365 
     end
   
     def daynote_for(date)
        return daynote if (date == nil)
        notes = Array.new
        daynote.each do |note|
          notes.push(note) if note.date == date
        end
        return notes
     end

     def photo_for(date)
       return photo if (date == nil)
       photos = Array.new
       photo.each do |photo|
         photos.push(photo) if photo.date == date
       end
       return photos
     end

end
