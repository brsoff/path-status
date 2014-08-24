class Tweet < ActiveRecord::Base
  before_create :record_phrases

  PHRASES = [
    'suspended',
    'signal problem',
    'signal failure',
    'signal construction',
    'track condition',
    'delay',
    'cash purchases only',
    'no credit/debit',
    'police activity',
    'car equipment problem',
    'station closed',
  ]

  def self.timeline(num_days)
    date_range = (num_days - 1).days.ago.beginning_of_day..Date.today.end_of_day
    tweets = Tweet.where(tweeted_at: date_range)

    timeline = {}
    reversed_days = (date_range.first.to_date..date_range.last.to_date).to_a.reverse

    reversed_days.each { |day|
      timeline[day.timeline_date] = tweets.select { |tweet|
        tweet.tweeted_at.localtime.to_date.timeline_date == day.timeline_date && tweet.phrases.present?
      }
    }

    timeline
  end

  def self.stats(timeline)
    phrases = timeline.map { |day, tweets|
      tweets.map { |tweet| tweet.phrases }.flatten
    }.flatten.join(', ')

    PHRASES.each_with_object(Hash.new) { |phrase, hash|
      hash[phrase] = phrases.scan(/#{ Regexp.quote(phrase) }/).size
    }
  end


private

  def record_phrases
    self.phrases = ''
    PHRASES.each { |p| self.phrases += "#{ p }, "  if tweet_text.include?(p) }
    self.phrases = phrases.present? ? phrases.gsub(/,\s$/, '') : nil
  end
end
