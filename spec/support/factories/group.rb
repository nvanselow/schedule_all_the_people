FactoryGirl.define do
  factory :group do
    sequence(:name) { |num| "Group #{num}" }
    user
  end
end
