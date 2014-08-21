class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :tweet_id
      t.datetime :tweeted_at
      t.text :tweet_text
      t.string :phrases
      t.timestamps
    end
  end
end
