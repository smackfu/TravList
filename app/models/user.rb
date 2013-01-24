require 'digest/sha1'

# this model expects a certain database layout and its based on the name/login pattern. 
class User < ActiveRecord::Base

  has_many :trip,    :dependent => true
  has_one :userpref

  # Please change the salt to something else, 
  # Every application should use a different one 
  @@salt = 'change-me'
  cattr_accessor :salt

  # Authenticate a user. 
  #
  # Example:
  #   @user = User.authenticate('bob', 'bobpass')
  #
  def self.authenticate(login, pass)
    find_first(["login = ? AND password = ?", login, sha1(pass)])
  end  

  def is_admin?
    return id == 1
  end

  def photos
    Photo.find_by_sql(["select * from photos left outer join userplaces on photos.userplace_id = userplaces.id left outer join trips on userplaces.trip_id = trips.id where flickr_id !='' and trips.user_id = ? order by photos.updated_at desc limit 4", id])
  end

  def blogphotos
    Photo.find(:all, :include=>{:userplace=>[{:place=>:country},:trip]}, :conditions => ["flickr_id !='' and trips.user_id = ?", id], :order=>"photos.created_at desc", :limit=>10 )
  end

  def blognotes
    Daynote.find(:all, :include=>[:notetype, {:userplace=>[{:place=>:country},:trip]}], :conditions => ["trips.user_id = ?", id], :order=>"daynotes.created_at desc", :limit=>10 )
  end
  
  def blogitems
    items = (blogphotos + blognotes).sort { |a, b| b.date <=> a.date }
  end
  
  def trips
    Trip.find(:all, :conditions => ["user_id = ? and fake = false", id], :order => "start desc")
  end

  def alltrips
    Trip.find(:all, :conditions => ["user_id = ?", id], :order => "start desc")
  end

  def notrip_userplaces
    Userplace.find(:all, :include => [:trip,{:place=>:country}], :conditions => ["trips.user_id = ? and trips.id = ?", id, userpref.notrip_trip_id], :order => "start_date desc, userplaces.id desc", :limit=>5)
  end
  
  def userplaces
    Userplace.find(:all, :include => [:trip,{:place=>:country}], :conditions => ["trips.user_id = ?", id], :order => "userplaces.updated_at desc, userplaces.id desc", :limit => 5)
  end
  
  def wishlist
    Userplace.find(:all, :include => [:trip,{:place=>:country}], :conditions => ["trips.user_id = ? and trips.id = ?", id, userpref.wishlist_trip_id], :order => "start_date desc, userplaces.id desc")
  end

  def trips_with(name)
    Trip.find_by_sql("select * from trips where user_id = #{id} and who_with like '%#{name}%'")
  end
  
  def userplaces_with(name)
    Userplace.find_by_sql("select userplaces.* from userplaces join trips on userplaces.trip_id = trips.id where trips.user_id = #{id} and userplaces.who_with like '%#{name}%'")
  end

  def userplaces_with_tag(tag)
      Userplace.find_tagged_with(:all=>tag, :conditions=>["trip_id in (select id from trips where trips.user_id = ?)",id])
  end
  
  def top_tags()
    Userplace.tags_count(:limit=>5, :raw=>true, :conditions=>["trip_id in (select id from trips where trips.user_id = ?)",id])
  end

  after_create :create_prefs

  def create_prefs
      @userpref = Userpref.new
      @userpref.user_id = self.id
      @userpref.save
  end

  protected

  # Apply SHA1 encryption to the supplied password. 
  # We will additionally surround the password with a salt 
  # for additional security. 
  def self.sha1(pass)
    Digest::SHA1.hexdigest("#{salt}--#{pass}--")
  end
    
  before_create :crypt_password
  
  # Before saving the record to database we will crypt the password 
  # using SHA1. 
  # We never store the actual password in the DB.
  def crypt_password
    write_attribute "password", self.class.sha1(password)
  end
  
  before_update :crypt_unless_empty
  
  # If the record is updated we will check if the password is empty.
  # If its empty we assume that the user didn't want to change his
  # password and just reset it to the old value.
  def crypt_unless_empty
    if password.empty?      
      user = self.class.find(self.id)
      self.password = user.password
    else
      write_attribute "password", self.class.sha1(password)
    end        
  end  
  
  validates_uniqueness_of :login, :on => :create

  validates_confirmation_of :password
  validates_length_of :login, :within => 3..40
  validates_length_of :password, :within => 5..40
  validates_presence_of :login, :password, :password_confirmation
end
