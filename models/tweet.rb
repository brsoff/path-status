class Tweet < ActiveRecord::Base
  before_create :record_phrases

  PHRASES = [
    'suspended',
    'signal problem',
    'signal failure',
    'signal construction',
    'track condition',
    'track problem',
    'delay',
    'cash purchases only',
    'no credit/debit',
    'police activity',
    'car equipment problem',
    'station closed',
    'min schedule',
    'minute schedule',
    'apologize',
    'sorry'
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

    frequency = PHRASES.each_with_object(Hash.new) { |phrase, hash|
      hash[phrase] = phrases.scan(/#{ Regexp.quote(phrase) }/).size
    }

    Hash[frequency.sort_by { |phrase, count| count }.reverse]
  end

  def self.by_phrase_in(timeline, phrase)
    timeline.map { |date, tweets|
      tweets.keep_if { |tweet| tweet.phrases.include?(phrase) }
    }
  end


private

  def record_phrases
    self.phrases = ''
    PHRASES.each { |p| self.phrases += "#{ p }, "  if tweet_text.downcase.include?(p) }
    self.phrases = phrases.present? ? phrases.gsub(/,\s$/, '') : nil
  end
end
