# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require_dependency "login_system" 

class ApplicationController < ActionController::Base
    include LoginSystem
    model :user
    before_filter :set_color
    before_filter :login_from_cookie

    def set_color
      @color = cookies[:color]
    end

    def login_from_cookie
      persist = Userpersist.find_by_cookie( cookies[:remember] ) if cookies[:remember] and @session[:user].nil?
      if persist
         user = User.find(persist.user_id)
         handle_login user
       end
    end

    def handle_login( user )
      @session[:user] = user
      #@session[:user_prefs] = YAML::load(user.prefs)
      #user.last_login = Time.now
      #user.save
    end

    def admin_required
      if @session[:user].id == 1
        return true
      end
      redirect_to :controller=>"account", :action =>"admin"
      return false
    end

    def rescue_action_in_public(exception)
      render :text => "<h1>Unexpected error</h1><p>Sorry. Hopefully this problem will fix itself when you hit reload.</p><p>If not, please report a bug using the link below.  Thanks.</p>", :layout=>'standard'
    end
    def local_request?
      false
    end
end
