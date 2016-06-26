# require 'google/apis/people_v1'
require 'modules/google_client'

class SessionController < ApplicationController
  include ApplicationHelper
  include GoogleClient

  def create
    user = User.find_or_create_from_omniauth(request.env['omniauth.auth'])
    session[:user_id] = user.id

    set_token

    redirect_to root_path
  end

  def destroy
    session[:user_id] = null;
  end

  private

  def set_token
    access_token = credentials['token']
    expires_at = credentials['expires_at']

    Token.create_or_update(user, access_token, expires_at)
  end

end
