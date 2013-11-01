#!/usr/bin/env ruby

require "rubygems"
require "instagram"
require "yaml"
require "net/http"
require "uri"
require "twitter_oauth"
require 'digest/md5'
require "json"


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


me = Instagram.user('self')
puts me.id
puts me.inspect

page_1 = Instagram.user_recent_media('self')
puts page_1
page_2_max_id = page_1.pagination.next_max_id
page_2 = Instagram.user_recent_media('self', :max_id => page_2_max_id ) unless page_2_max_id.nil?
puts page_2
page_3_max_id = page_2.pagination.next_max_id
page_3 = Instagram.user_recent_media('self', :max_id => page_3_max_id ) unless page_3_max_id.nil?
puts page_3

# puts Instagram.user_search("barce")
# puts Instagram.location_search("37.7808851","-122.3948632")




