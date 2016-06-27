FactoryGirl.define do
  factory :event do
    sequence(:name) { |num| "Event #{num}" }
    user
    group
    slot_duration 15
  end
end
