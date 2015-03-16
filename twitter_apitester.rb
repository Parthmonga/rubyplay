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

# url
# alerts
# send DMs to this account
# regex

# puts client.inspect
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


# @replies = 0
# (16..16).each { |i|
#   puts "page: #{i}"
#   timeline = client.user_timeline("count" => 3200, "screen_name" => 'meganberry', "page" => i)
#   @replies = @replies + get_replies(timeline)
#   sleep 5
# }

timeline = client.user_timeline("count" => 10, "screen_name" => 'chrisheuer', "page" => 1)
puts timeline.inspect

# puts "megan did: "
# puts @replies
# puts "out of 3200 tweets."
# puts timeline.count
# timeline.each { |tl| puts tl.inspect # puts tl['text'] }
# client.message("#{ARGV[2].chomp}", "something's changed with #{s.url} : alert #{i}")

