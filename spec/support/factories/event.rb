FactoryGirl.define do
  factory :event do
    sequence(:name) { |num| "Event #{num}" }
    user
    group
    slot_duration 15
    calendar_id 1
    calendar_name "test calendar 1"
  end
end
