class Tweet < ActiveRecord::Base
  before_create :record_phrases

  PHRASES = [
    'has been suspended',
    'signal problem',
    'signal construction',
    'track condition',
    'is suspended',
    'delay',
    'cash purchases only',
    'no credit/debit',
    'police activity',
    'operating with a delay',
    'car equipment problem',
    'station closed',
    'subject to a'
  ]

  def self.timeline(num_days)
    date_range = (num_days - 1).days.ago.beginning_of_day..Date.today.end_of_day
    tweets = Tweet.where(tweeted_at: date_range)

    timeline = {}

    (date_range.first.to_date..date_range.last.to_date).each { |day|
      timeline[day.timeline_date] = tweets.select { |tweet|
        tweet.tweeted_at.to_date.timeline_date == day.timeline_date
      }
    }

    timeline
  end


private

  def record_phrases
    self.phrases = ''
    PHRASES.each { |p| self.phrases += "#{ p },"  if tweet_text.include?(p) }
    self.phrases = phrases.present? ? phrases.gsub(/,$/, '') : nil
  end
end
