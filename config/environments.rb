configure :development do
ActiveRecord::Base.establish_connection(
  :adapter => "postgresql",
  :host => "localhost",
  :username => ENV['PG_USER'],
  :database => "path_status",
  :encoding => "utf8",
  :pool => 8
  )
end
