module UserplaceHelper

  def format_date(userplace)

    %(xxx)

    if userplace.start_date 
      userplace.start_date.strftime('%a, %b %e, %Y')
      if userplace.end_date 
        'to'+userplace.end_date.strftime('%a, %b %e, %Y')
      end

      #'(planned)' if userplace.start_date > DateTime.now
    end
    #if !userplace.trip.fake
    #end

  end

end
