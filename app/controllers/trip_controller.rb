class TripController < ApplicationController
    before_filter :login_required, :except => [ 'show', 'list', 'map', 'allnotes','rss' ]
    layout "standard", :except => ['editdate', 'rss']
    scaffold :trip
    require 'flick'
    caches_page :rss

  def index
        redirect_to :action => 'list'
  end

  def edit
      @trip = Trip.find(params[:id])
      if @session[:user] != @trip.user
        redirect_to :action => 'show', :id => @trip
      end
  end

  def allnotes
      @trip = Trip.find(params[:id])
      @daynotes = Daynote.find(:all, :include=>['userplace'], :conditions => ["trip_id = ?", @trip.id], :order=> "date, userplaces.id")
  end

  def show
      @trip = Trip.find(params[:id],:include => {:userplace=>[{:place=>:country}, :daynote, :photo]})
      
      if (@trip.fake)
        redirect_to :controller => 'user', :action => 'show', :id => @trip.user and return
      end
      
      @days = Hash.new
      @tripstart = @trip.start
      for userplace in @trip.userplace
          if userplace.start_date
            startjd = userplace.start_date.jd
            if userplace.end_date
              endjd = userplace.end_date.jd
            else
              endjd =  userplace.start_date.jd
            end
          else
            startjd = @trip.start.jd - 1;
            endjd = startjd;
          end
          for i in startjd..endjd
            dayno = i - @trip.start.jd + 1
            @days[dayno] = Array.new if !@days[dayno]
            @days[dayno].push(userplace)
          end
    end

#      @dn = Hash.new
#      @daynotes = Daynote.find(:all, :include=>'userplace', :conditions => ["trip_id = ?", @trip.id])
#      @daynotes.each do |note|
#        @dn[note.userplace_id.to_s+note.date.to_s] = note; 
#      end

#      @ph = Hash.new
#      @trip.photos.each do |photo|
#        @ph[photo.userplace_id.to_s+photo.date.to_s] = photo; 
#      end
  end

  def rss
    @trip = Trip.find(params[:id],:include => {:userplace=>{:place=>:country}}, :order => "userplaces.start_date desc")
  end

  def list
     @trips = Trip.find(:all, :conditions => "fake = false")
  end

  def create
    @trip = Trip.new(params[:trip])
    if @trip.save
      flash[:notice] = 'Trip was successfully created.'
      redirect_to :action => 'show', :id => @trip
    else
      render :action => 'new'
    end
  end

  def map
     @trip = Trip.find(params[:id],:include => {:userplace=>[{:place=>:country} ]})
     
     @maxlat = -999; @maxlong = -999;
     @minlat = 999; @minlong = 999;
     @errors = Array.new 
     @userplaces = Array.new
 
     for userplace in @trip.userplace.sort { |a, b| (a.start_date == nil ? -1 : ( b.start_date == nil ? +1 : (a.start_date <=> b.start_date))) }
        next if userplace.nomap
        if userplace.place.lat == 0
           @errors.push userplace.place
        else
           @maxlat = userplace.place.lat if userplace.place.lat > @maxlat
           @minlat = userplace.place.lat if userplace.place.lat < @minlat
           @maxlong = userplace.place.long if userplace.place.long > @maxlong
           @minlong = userplace.place.long if userplace.place.long < @minlong
           @userplaces.push userplace
        end
     end

  end

  def destroy
    trip = Trip.find(params[:id])
    if @session[:user] != trip.user
       redirect_to :action => 'show', :id => params[:id] and return
    end
    trip.destroy
    redirect_to :controller => 'user', :action=>'show', :id => @session[:user].id
  end
  
  def updatename
     trip = Trip.find(params[:id])
     trip.name = params[:value]
     trip.save
     render :text => trip.name
  end

  def updatecomment
     trip = Trip.find(params[:id])
     trip.comment = params[:value]
     trip.save
     render :text => auto_link(h(trip.comment).gsub("\n","<br>")) 
  end

  def updatedate
    @trip = Trip.find(params[:id])
    if @trip.update_attributes(params[:trip])
      render :partial => 'date'
    end
  end

  
  def editdate
    @trip = Trip.find(params[:id])
  end

end
