class Photo < ActiveRecord::Base
  require 'flick'

  belongs_to :userplace

  def before_save
    begin 
      fphoto = Flickr::Photo.new(self.flickr_id)
      self.flickr_img = fphoto.source('Small').gsub('_m.jpg','')
      self.flickr_url = fphoto.url
      self.caption = fphoto.title if self.caption.blank?
   rescue
   end
  end

end
