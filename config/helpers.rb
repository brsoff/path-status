helpers do
  def render_day_for(day, max)
    partial :tweets, locals: { date: day.first, tweets: day.second, max: max }
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

  def tweet_link_for(id)
    "http://twitter.com/pathalerts/status/#{ id }"
  end

  def render_date_class_for(date)
    'weekend'  if date.match('Sat|Sun')
  end

  def count_phrases_in(tweets)
    tweets.map { |tweet| tweet.phrases }.join(', ').split(', ').size
  end

  def render_total_stats_for(stats)
    stats.map { |s| s.second }.sum
  end

  def render_no_phrases_class_for(tweets)
    'no-phrases'  if tweets.size == 0
  end

  def node_position_for(node, count)
    node.to_f / count.to_f * 100
  end
end
