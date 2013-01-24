class Place < ActiveRecord::Base
    belongs_to :country
    has_many :userplaces

    validates_uniqueness_of :name, :on => :create

    def before_save

      if (self.lat == 0)
         urlname = self.name.tr(' ','+')
         result = Net::HTTP.get 'brainoff.com', '/geocoder/rest/?city='+urlname+','+self.country.fipscode
         if result
            result =~ /<geo:long>(.*)<\/geo:long>/
            if $1
               self.long = $1.to_f
            end
            result =~ /<geo:lat>(.*)<\/geo:lat>/
            if $1
               self.lat = $1.to_f
            end
         end
      end
    end
end
