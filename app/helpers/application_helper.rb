module ApplicationHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def format_time(time, time_zone, format_option = :both)
    if(format_option == :both)
      format_string = '%-m/%-d/%y %-I:%M %p'
    elsif(format_option == :date_only)
      format_string = '%-m/%-d/%y'
    else
      format_string = '%-I:%M %p'
    end
    time.in_time_zone(time_zone).strftime(format_string)
  end
end
