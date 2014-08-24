helpers do
  def render_day_for(day, max)
    date = day.first
    tweets = day.second

    p = tweets.empty? ? :no_tweets : :tweets
    partial p, locals: { date: date, tweets: tweets, max: max }
  end

  def max_phrases_for(timeline)
    timeline.map { |k, v| v.size }.max
  end

  def days_in(timeline)
    timeline.keys.size
  end

  def render_width_for(tweets, max)
    (tweets.size.to_f / max.to_f) * 100
  end
end
