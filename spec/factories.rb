FactoryGirl.define do
  factory :tweet do
    tweet_text { Faker::Lorem.sentence }
    tweeted_at { Time.at((Time.now.to_i - 7.days.ago.to_i) * rand + Time.now.to_i) }
  end
end
