#!/usr/bin/env ruby

require "rubygems"
require "instagram"
require "yaml"
require "net/http"
require "uri"
require "twitter_oauth"
require 'digest/md5'
require "json"
require "date"


yamlstring = ''
File.open("./auth.yaml", "r") { |f|
  yamlstring = f.read
}

@settings = YAML::load(yamlstring)
puts @settings.inspect

@access_token = @settings['access_token']
Instagram.configure do |config|
  config.client_id = @settings['client_id']
  config.access_token = @access_token
end


#  633269381 <-- gscalini
# 1385944769 <-- flyingthroughfilm
id = 1385944769 + 7812740
start_id = id
finish_id = id + 100
# me = Instagram.user(id)

# puts me.inspect

# exit

html = "<h1>recent photos for #{id}</h1>"

# for media_item in Instagram.user_recent_media(id)
#   puts media_item.caption.text
#   puts DateTime.strptime(media_item.caption.created_time, "%s")
# end
# puts html

(start_id..finish_id).each do |id|
  begin
    puts Instagram.user(id).inspect
    media_items = Instagram.user_recent_media(id)
    if media_items
      media_item = media_items.first
      puts "#{id}:#{DateTime.strptime(media_item.caption.created_time, "%s")}"
    end
  rescue => details
    puts details.inspect
  end
  media_items = nil
end

# puts Instagram.user_search("gscalini")
# puts Instagram.location_search("37.7808851","-122.3948632")




