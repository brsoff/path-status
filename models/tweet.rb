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
  ]


private

  def record_phrases
    self.phrases = ''
    PHRASES.each { |p| self.phrases += "#{ p },"  if tweet_text.include?(p) }
    self.phrases = phrases.present? ? phrases.gsub(/,$/, '') : nil
  end
end
