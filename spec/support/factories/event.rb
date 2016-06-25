FactoryGirl.define do
  factory :event do
    sequence(:name) { |num| "Event #{num}" }
    user
  end
end
