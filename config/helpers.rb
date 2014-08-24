helpers do
  def render_tweets_for(timeline)
    p = timeline.empty? ? :no_tweets : :tweets
    partial p, locals: { timeline: timeline }
  end
end
