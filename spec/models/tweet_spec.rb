require 'spec_helper'

describe Tweet do
  subject { build(:tweet) }
  let(:tweets) { create_list(:tweet, 3, tweeted_at: Time.now.beginning_of_day) }

  describe "self.timeline" do
    before {
        tweets.second.tweeted_at = 10.days.ago
        tweets.second.save!

        tweets.third.phrases = 'signal problem'
        tweets.third.tweeted_at = 3.days.ago
        tweets.third.save!
      }

    context "given an integer" do
      it "should return keys that correspond to specified days" do
        expect(Tweet.timeline(7).keys).to include(Date.today.timeline_date)
        expect(Tweet.timeline(7).keys).to include((Date.today - 6.days).timeline_date)
        expect(Tweet.timeline(7).keys).not_to include((Date.today - 7.days).timeline_date)
      end

      it "should return values as array of tweets with phrases tweeted on that day" do
        expect(Tweet.timeline(7)[tweets.first.tweeted_at.to_date.timeline_date]).not_to include(tweets.first)
        expect(Tweet.timeline(7)[tweets.second.tweeted_at.to_date.timeline_date]).to eq(nil)
        expect(Tweet.timeline(7)[tweets.third.tweeted_at.to_date.timeline_date]).to include(tweets.third)
      end
    end
  end

  describe "self.stats" do
    let(:timeline) { Tweet.timeline(7) }

    before {
      tweets.first.phrases = 'signal problem, delay, signal construction'
      tweets.second.phrases = 'delay, police activity'
      tweets.third.phrases = 'signal construction, delay'
      tweets.each { |tweet| tweet.save! }
    }

    context "given a timeline" do
      it "should return hash of PHRASES with usage frequency" do
        expect(Tweet.stats(timeline)['signal problem']).to eq(1)
        expect(Tweet.stats(timeline)['delay']).to eq(3)
        expect(Tweet.stats(timeline)['signal construction']).to eq(2)
        expect(Tweet.stats(timeline)['track condition']).to eq(0)
      end
    end
  end

  describe "record_phrases" do
    context "tweet contains one phrase" do
      before {
        subject.tweet_text = "Concerning the earlier signal problem, all PATH train service is resuming normal schedule."
        subject.save!
      }

      it "should save the phrase" do
        expect(subject.phrases).to eq("signal problem")
      end
    end

    context "tweet contains multiple phrases" do
      before {
        subject.tweet_text = "Due to a signal problem, all PATH train service has been suspended."
        subject.save!
      }

      it "should save multiple phrases" do
        expect(subject.phrases).to eq("suspended, signal problem")
      end
    end

    context "tweet does not contain any phrases" do
      before {
        subject.tweet_text = "Unrelated tweet"
        subject.save!
      }

      it "should save as nil if no phrases are detected" do
        expect(subject.phrases).to eq(nil)
      end
    end
  end
end
