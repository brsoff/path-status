require 'spec_helper'

describe Tweet do
  subject { build(:tweet) }
  let(:tweets) { create_list(:tweet, 3, tweeted_at: Time.now.beginning_of_day) }

  context "self.timeline" do
    it "should return a hash" do
      expect(Tweet.timeline(7)).to be_a Hash
    end

    it "should return keys that correspond to specified days" do
      expect(Tweet.timeline(7).keys).to include(Date.today.timeline_date)
      expect(Tweet.timeline(7).keys).to include((Date.today - 6.days).timeline_date)
      expect(Tweet.timeline(7).keys).not_to include((Date.today - 7.days).timeline_date)
    end

    it "should return values as array of tweets tweeted on that day" do
      tweets.second.tweeted_at = 10.days.ago
      tweets.second.save!

      tweets.third.tweeted_at = 3.days.ago
      tweets.third.save!

      expect(Tweet.timeline(7)[tweets.first.tweeted_at.to_date.timeline_date]).to include(tweets.first)
      expect(Tweet.timeline(7)[tweets.third.tweeted_at.to_date.timeline_date]).to include(tweets.third)
      expect(Tweet.timeline(7)[tweets.second.tweeted_at.to_date.timeline_date]).to eq(nil)
    end
  end

  context "record_phrases" do
    it "should save a phrase if detected in the body of a tweet" do
      subject.tweet_text = "Concerning the earlier signal problem, all PATH train service is resuming normal schedule."
      subject.save!

      expect(subject.phrases).to eq("signal problem")
    end

    it "should save multiple phrases if detected in the body of a tweet" do
      subject.tweet_text = "Due to a signal problem, all PATH train service has been suspended."
      subject.save!

      expect(subject.phrases).to eq("has been suspended,signal problem")
    end

    it "should save as nil if no phrases are detected" do
      subject.tweet_text = "Unrelated tweet"
      subject.save!

      expect(subject.phrases).to eq(nil)
    end
  end
end
