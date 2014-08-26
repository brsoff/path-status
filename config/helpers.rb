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

  def chop_year_for(date)
    date.gsub(/\/\d\d$/, '')
  end

  # below taken from https://github.com/nesquena/sinatra_more

  def partial(template, options={})
    options.reverse_merge!(:locals => {}, :layout => false)
    path = template.to_s.split(File::SEPARATOR)
    object_name = path[-1].to_sym
    path[-1] = "_#{path[-1]}"
    template_path = File.join(path)
    raise 'Partial collection specified but is nil' if options.has_key?(:collection) && options[:collection].nil?
    if collection = options.delete(:collection)
      options.delete(:object)
      counter = 0
      collection.collect do |member|
        counter += 1
        options[:locals].merge!(object_name => member, "#{object_name}_counter".to_sym => counter)
        render_template(template_path, options.merge(:layout => false))
      end.join("\n")
    else
      if member = options.delete(:object)
        options[:locals].merge!(object_name => member)
      end
      render_template(template_path, options.merge(:layout => false))
    end
  end

  def render_template(template_path, options={})
    render :erb, template_path.to_sym, options
  end
end
