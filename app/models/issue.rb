class Issue < ActiveRecord::Base

   validates_format_of :url, :with => /travlist.com/, :message => 'must be at this site'
   validates_presence_of :description
   
end
