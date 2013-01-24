class UserprefController < ApplicationController
    before_filter :login_required, :only => [ 'edit', 'update' ]
    layout "standard"

    def edit
      @userpref = Userpref.find(params["id"])
      if @session[:user] != @userpref.user
        redirect_to :controller=> 'user', :action => 'show', :id => @userpref.user
        return
      end
    end

    def update
      @userpref = Userpref.find(params["id"])
      if @userpref.update_attributes(params[:userpref])
        flash[:notice] = 'Preferences were successfully updated.'
        redirect_to :controller=> 'user', :action => 'show', :id => @userpref.user
      else
        render :action => 'edit'
      end
    end

    
end
