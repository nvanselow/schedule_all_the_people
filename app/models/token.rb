require 'net/http'
require 'json'

class Token < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :provider, presence: true
  validates :access_token, presence: true
  validates :expires_at, presence: true, timeliness: :on

  def self.create_or_update(user, access_token, expires_at, refresh_token = nil)
    token = user.tokens.where(provider: user.provider).first

    if(token)
      token.access_token = access_token
      token.refresh_token = refresh_token if refresh_token
      token.expires_at = Time.at(expires_at).to_datetime
      token.save
    else
      user.tokens.create(
        provider: user.provider,
        access_token: access_token,
        refresh_token: refresh_token,
        expires_at: Time.at(expires_at).to_datetime
      )
    end
  end

  def to_params
    {'refresh_token' => refresh_token,
    'client_id' => ENV['CLIENT_ID'],
    'client_secret' => ENV['CLIENT_SECRET'],
    'grant_type' => 'refresh_token'}
  end

  def request_token_from_google
    url = URI("https://accounts.google.com/o/oauth2/token")
    Net::HTTP.post_form(url, self.to_params)
  end

  def refresh!
    # response = request_token_from_google
    # data = JSON.parse(response.body)
    # update_attributes(
    #   access_token: data['access_token'],
    #   expires_at: Time.now + (data['expires_in'].to_i).seconds
    # )

    # For some reason, I can't get a refresh token so need to sign in again
    redirect_to '/auth/google_oauth2'
    nil
  end

  def expired?
    expires_at < Time.now
  end

  def fresh_token
    return refresh! if expired?
    access_token
  end
end
