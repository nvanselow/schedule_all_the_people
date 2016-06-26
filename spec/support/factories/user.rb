FactoryGirl.define do
  factory :user do
    sequence(:uid) { |num| "uuid-#{num}"}
    provider "some_oauth_provider"
    first_name "Gavin"
    last_name "Guile"
    avatar_url "https://placebear.com/25/25"
    sequence(:email) { |num| "gavin_guile_#{num}@test.com" }
  end
end
