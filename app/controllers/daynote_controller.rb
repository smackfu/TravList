class DaynoteController < ApplicationController
  before_filter :login_required, :only => [ 'edit', 'new', 'create', 'destroy' ]
  layout "standard", :except => ['new', 'destroy', 'edit',]

  def new
    @daynote = Daynote.new
    @daynote.date = params[:date]
    @notetypes = Notetype.find_all
    @userplace = Userplace.find(params[:userplace_id])
    @daynote.userplace_id = @userplace.id
  end

  def create
    @daynote = Daynote.new(params[:daynote])
    @userplace = Userplace.find(@daynote.userplace_id)
    if @daynote.save
      render :partial => "show", :locals => { :show => @daynote }
    else
      render :action => 'new'
    end
  end

  def edit
    @daynote = Daynote.find(params[:id])
    @notetypes = Notetype.find_all
    @userplace = Userplace.find(@daynote.userplace_id)
  end

  def update
    @daynote = Daynote.find(params[:id])
    @userplace = Userplace.find(@daynote.userplace_id)
    if @daynote.update_attributes(params[:daynote])
      flash[:notice] = 'Daynote was successfully updated.'
      redirect_to :controller=> 'userplace', :action => 'show', :id => @userplace, :date => @daynote.date
    else
      render :action => 'edit'
    end
  end

  def destroy
    @daynote = Daynote.find(params[:id])
    daynotedate = @daynote.date
    @userplace = Userplace.find(@daynote.userplace_id)
    @daynote.destroy
    render :nothing => true
    #redirect_to :controller=> 'userplace', :action => 'show', :id => @userplace, :date => daynotedate
  end

end
