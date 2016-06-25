FactoryGirl.define do
  factory :user do
    sequence(:uuid) { |num| "uuid-#{num}"}
    first_name "Gavin"
    last_name "Guile"
    avatar_url "https://placebear.com/25/25"
    sequence(:email) { |num| "gavin_guile_#{num}@test.com" }
  end
end
