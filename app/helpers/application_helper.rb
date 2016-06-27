module ApplicationHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def format_time(time, time_zone, include_date = true)
    if(include_date)
      format_string = '%-m/%-d/%y %-I:%M %p'
    else
      format_string = '%-I:%M %p'
    end
    time.in_time_zone(time_zone).strftime(format_string)
  end
end
