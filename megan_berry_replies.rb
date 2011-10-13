#!/usr/bin/env ruby


require "rubygems"
require "mysql"
require "date"
require "yaml"
require "net/http"
require "uri"
require "twitter_oauth"
require 'digest/md5'

puts "Hi"


yamlstring = ''
File.open("./auth.yaml", "r") { |f|
  yamlstring = f.read
}

settings = YAML::load(yamlstring)
puts settings.inspect


if settings['access_token'].nil?

  puts "use get_oauth.rb to fill out info for access_token and access_secret."

end


client = TwitterOAuth::Client.new(
	    :consumer_key => settings['consumer_key'],
	    :consumer_secret => settings['consumer_secret'],
	    :token => settings['access_token'],
	    :secret => settings['access_secret']
)






puts "authorized? #{client.authorized?}"

# count # of twitter replies sent
def get_replies(timeline)
  i = 0
  timeline.each { |tl|
    unless tl['in_reply_to_status_id'].nil?
      i = i + 1
    end
  }
  puts "i: #{i}"
  return i
end


@replies = 0
(1..16).each { |i|
  puts "page: #{i}"
  begin
    timeline = client.user_timeline("count" => 3200, "screen_name" => 'meganberry', "page" => i)
    @replies = @replies + get_replies(timeline)
  rescue JSON::ParserError
    puts "skipping page #{i}"
  end
  puts "replies: #{@replies}"
  sleep 5
}

puts "megan did: "
puts @replies
puts "out of 3200 tweets."
