require 'spec_helper'

describe Tweet do
  subject { Tweet.new }

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
