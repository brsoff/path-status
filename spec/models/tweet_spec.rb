require 'spec_helper'

describe Tweet do
  subject { build(:tweet) }
  let(:tweets) { create_list(:tweet, 3, tweeted_at: Time.now.beginning_of_day) }

  context "self.timeline" do
    it "should return keys that correspond to specified days" do
      timeline = Tweet.timeline(7)

      expect(timeline.keys).to include(Date.today.timeline_date)
      expect(timeline.keys).to include((Date.today - 6.days).timeline_date)
      expect(timeline.keys).not_to include((Date.today - 7.days).timeline_date)
    end

    it "should return values as array of tweets with phrases tweeted on that day" do
      tweets.second.tweeted_at = 10.days.ago
      tweets.second.save!

      tweets.third.phrases = 'signal problem'
      tweets.third.tweeted_at = 3.days.ago
      tweets.third.save!

      timeline = Tweet.timeline(7)

      expect(timeline[tweets.first.tweeted_at.to_date.timeline_date]).not_to include(tweets.first)
      expect(timeline[tweets.second.tweeted_at.to_date.timeline_date]).to eq(nil)
      expect(timeline[tweets.third.tweeted_at.to_date.timeline_date]).to include(tweets.third)
    end
  end

  context "self.stats" do
    it "should return hash of PHRASES with usage frequency" do
      tweets.first.phrases = 'signal problem, delay, signal construction'
      tweets.second.phrases = 'delay, police activity'
      tweets.third.phrases = 'signal construction, delay'

      tweets.each { |tweet| tweet.save! }

      timeline = Tweet.timeline(7)
      stats = Tweet.stats(timeline)

      expect(stats['signal problem']).to eq(1)
      expect(stats['delay']).to eq(3)
      expect(stats['signal construction']).to eq(2)
      expect(stats['track condition']).to eq(0)
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

      expect(subject.phrases).to eq("suspended, signal problem")
    end

    it "should save as nil if no phrases are detected" do
      subject.tweet_text = "Unrelated tweet"
      subject.save!

      expect(subject.phrases).to eq(nil)
    end
  end
end
