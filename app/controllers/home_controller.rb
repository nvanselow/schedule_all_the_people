class HomeController < ApplicationController
  def index
    if(current_user)
      @groups = Group.all
      @events = Event.all
    end
  end
end
