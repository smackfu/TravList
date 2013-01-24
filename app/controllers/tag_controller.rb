class TagController < ApplicationController
    layout "standard"

    def show
        @tagname = params[:id]
        @tagplaces = Userplace.find_tagged_with(:all=>@tagname)
    end 

    def list
        @tags = Tags.tags_count
    end 
    
end
