FactoryBot.define do
  factory :transaction do
    association :user
    amount { Random.new.rand(9999) }
  end
end
