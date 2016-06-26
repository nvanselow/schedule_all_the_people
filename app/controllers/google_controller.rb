class GoogleController < ApplicationController
  def create
    redirect_to client.authorization_uri.to_s
  end
end
