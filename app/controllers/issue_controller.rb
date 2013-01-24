class IssueController < ApplicationController
  before_filter :login_required, :only => [ 'list', 'edit', 'show' ]
  before_filter :admin_required, :only => [ 'list' ]
  layout "standard"

  def show
    @issue = Issue.find(params[:id])
    @user = User.find(@issue.user_id) if @issue.user_id != 0
    if @session[:user].id == 1
      @issues = Issue.find_all_by_url(@issue.url, :order=>'closed, id desc')
    else
      @issues = Array.new
    end
  end

  def list
    #redirect_to @request.env['HTTP_REFERER'] if @session[:user].id != 1
    @issue_pages, @issues = paginate :issues, :per_page => 30, :order => 'closed, id desc'
  end

  def listyours
    @userid = @session[:user].id if @session[:user]
    @issue_pages, @issues = paginate :issues, :per_page => 30, :order => 'closed, id desc', :conditions => ["user_id = ?", @userid]
    render :action => 'list'
  end

  def new
    @userid = '0';
    @userid = @session[:user].id if @session[:user]
    @issue = Issue.new
    @session[:return_to] = @request.env['HTTP_REFERER']
    @issue.url =  @request.env['HTTP_REFERER']

  end

  def create
    @issue = Issue.new(params[:issue])
    if @issue.save
      flash[:notice] = 'Suggestion/bug was successfully entered.'
      redirect_to @session[:return_to]
      @session[:return_to] = nil
    else
      render :action => 'new'
    end
  end

  def edit
    redirect_to @request.env['HTTP_REFERER'] if @session[:user].id != 1
    @issue = Issue.find(params[:id])
  end

  def update
    @issue = Issue.find(params[:id])
    if @issue.update_attributes(params[:issue])
      flash[:notice] = 'Issue was successfully updated.'
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    redirect_to @request.env['HTTP_REFERER'] if @session[:user].id != 1
    issue = Issue.find(params[:id])
    issue.destroy
    redirect_to :controller=> 'issue', :action => 'list'
  end

end
