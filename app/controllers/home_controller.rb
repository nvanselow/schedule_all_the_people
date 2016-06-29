class HomeController < ApplicationController
  def index
    if(current_user)
      @groups = Group.all_for_user(current_user)
      @events = Event.all_for_user(current_user)
    end
  end
end
