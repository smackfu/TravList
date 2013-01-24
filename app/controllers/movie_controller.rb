class MovieController < ApplicationController
  before_filter :login_required, :only => [ 'edit', 'new', 'create', 'destroy' ]
  layout "standard"

  def new
    @movie = Movie.new
    @movie.date = params[:date]
    @userplace = Userplace.find(params[:userplace_id])
    @movie.userplace_id = @userplace.id
  end

  def create
    @movie = Movie.new(params[:movie])
    @userplace = Userplace.find(@movie.userplace_id)
    if @movie.save
      flash[:notice] = 'Movie was successfully added.'
      redirect_to :controller=> 'userplace', :action => 'show', :id => @userplace, :date => @movie.date
    else
      render :action => 'new'
    end
  end

  def edit
    @movie = Movie.find(params[:id])
    @userplace = Userplace.find(@movie.userplace_id)
  end

  def update
    @movie = Movie.find(params[:id])
    @userplace = Userplace.find(@movie.userplace_id)
    if @movie.update_attributes(params[:movie])
      flash[:notice] = 'Movie was successfully updated.'
      redirect_to :controller=> 'userplace', :action => 'show', :id => @userplace, :date => @movie.date
    else
      render :action => 'edit'
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    moviedate = @movie.date
    @userplace = Userplace.find(@movie.userplace_id)
    @movie.destroy
    render :nothing => true
  end

end
