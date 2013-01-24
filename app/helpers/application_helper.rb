# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
                                  from_time = from_time.to_time if from_time.respond_to?(:to_time)
                                  to_time = to_time.to_time if to_time.respond_to?(:to_time)
                                  distance_in_minutes = (((to_time - from_time).abs)/60.0).round
                                  distance_in_seconds = ((to_time - from_time).abs).round
    case distance_in_minutes
      when 0..1
      return (distance_in_minutes==0) ? 'less than a minute' : '1 minute' unless include_seconds
      case distance_in_seconds
        when 0..5   then 'less than 5 seconds'
        when 6..10  then 'less than 10 seconds'
        when 11..20 then 'less than 20 seconds'
        when 21..40 then 'half a minute'
        when 41..59 then 'less than a minute'
        else             '1 minute'
        end
        when 2..45          then "#{distance_in_minutes} minutes"
        when 46..90         then 'about 1 hour'
        when 90..1440       then "about #{(distance_in_minutes.to_f / 60.0).round} hours"
        when 1441..2880     then '1 day'
        when 2881..43200    then "#{(distance_in_minutes / 1440.0).round} days"
        when 43201..475200  then pluralize((distance_in_minutes / 43200.0).round, 'month')
        else                     "about "+pluralize((distance_in_minutes / 525600.0).round, 'year')  
      end
    end  

    def get_user
      return session[:user]
    end

    def is_admin
      return false if !logged_in
      return (get_user.id == 1)
    end

    def logged_in
      return (get_user != nil)
    end

    def is_owner(owner)
      if logged_in
        return (get_user.id == owner.id)
      else
        return false
      end
    end
    
end
