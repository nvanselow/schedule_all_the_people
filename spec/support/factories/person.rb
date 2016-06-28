FactoryGirl.define do
  factory :person do
    sequence(:first_name) { |num| "Person #{num}"}
    last_name "Guile"
    sequence(:email) { |num| "gavin_guile_#{num}@test.com" }
  end
end
