module AuthenticationHelper
  def sign_in_as(user)
    mock_auth_for(user)
    visit "/"
    click_link "Sign In"
    expect(page).to have_content(user.email)
  end

  def mock_auth_for(user)
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      "provider" => user.provider,
      "uid" => user.uid,
      "info" => {
        "nickname" => "",
        "email" => user.email,
        "first_name" => user.first_name,
        "last_name" => user.last_name,
        "image" => user.avatar_url,
      },
      "credentials" => {
        "token" => "1234",
        "expires_at" => DateTime.parse("2018-06-26 18:17:34 -0400")
      },
      "extra" => {
        "raw_info" => {
          "login" => "",
          "id" => user.uid.to_s,
          "avatar_url" => user.avatar_url,
          "gravatar_id" => "",
          "url" => "",
          "html_url" => "",
          "followers_url" => "",
          "following_url" => "",
          "gists_url" => "",
          "starred_url" => "",
          "subscriptions_url" => "",
          "organizations_url" => "",
          "repos_url" => "",
          "events_url" => "",
          "received_events_url" => "",
          "type" => "User",
          "site_admin" => false,
          "name" => user.first_name,
          "company" => nil,
          "blog" => nil,
          "location" => "",
          "email" => user.email,
          "hireable" => true,
          "bio" => nil,
          "public_repos" => 0,
          "public_gists" => 0,
          "followers" => 0,
          "following" => 0,
          "created_at" => "",
          "updated_at" => ""
        }
      }
    )
  end
end
