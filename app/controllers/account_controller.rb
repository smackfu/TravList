class AccountController < ApplicationController
  layout  'standard'

  def login
    case @request.method
    when :post
      if user = User.authenticate(@params[:user_login], @params[:user_password])
        handle_login(user)
        if @params[:remember_me]
          create_remember(user)
        end
        flash['notice']  = "Login successful"
        redirect_back_or_default :controller=>'meta', :action => 'index'
      else
        flash.now['notice']  = "Login unsuccessful"
        @login = @params[:user_login]
      end
    when :get
      @session[:return_to] = @request.env['HTTP_REFERER'] 
    end
  end

  def create_remember(user)
    persist = Userpersist.new
    persist.user_id = user.id
    persist.cookie = randomstring(20)+user.login
    persist.save

    cookies[:remember] =  { :value=>persist.cookie, :expires => Time.now + ( 365 * (60*60*24)), :domain => '.travlist.com'} 
  end

  def randomstring( len )
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    val = ""
    1.upto(len) { |i| val << chars[rand(chars.size-1)] }
    return val
  end  
  
  def signup
    @user = User.new(@params[:user])

    if @request.post? and @user.save
      user = User.authenticate(@user.login, @params[:user][:password])
      handle_login(user)
      if @params[:remember_me]
        create_remember(user)
      end
      flash['notice']  = "Signup successful"
      redirect_to :controller=>'meta', :action => 'welcome'
    end
  end  
  
  def logout
    @session[:user] = nil
    @session[:return_to] = @request.env['HTTP_REFERER'] 
    persist = Userpersist.find_by_cookie( cookies[:remember] )
    persist.destroy if persist
    cookies.delete :remember
    redirect_back_or_default :controller=>'meta', :action => 'index'
  end
    
  def welcome
  end

  def admin
  end
  
end
