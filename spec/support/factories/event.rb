FactoryGirl.define do
  factory :event do
    sequence(:name) { |num| "Event #{num}" }
    user
    group
  end
end
