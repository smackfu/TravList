class SystemnoteController < ApplicationController
  before_filter :login_required, :except => [ 'list' ]
  before_filter :admin_required, :except => [ 'list' ]
  layout "standard"

  scaffold :systemnote

  def list

    if @session[:user].id == 1
      @systemnotes = Systemnote.find(:all, :order=>'start_date desc')
    else
      @systemnotes = Systemnote.find(:all, :conditions=>'start_date <= now()', :order=>'start_date desc')
    end

  end

end
