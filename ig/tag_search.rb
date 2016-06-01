#!/usr/bin/env ruby

require "rubygems"
require "instagram"
require "yaml"
require "net/http"
require "uri"
require "twitter_oauth"
require 'digest/md5'
require "json"
require 'hashie'

yamlstring = ''
File.open("./auth.yaml", "r") { |f|
  yamlstring = f.read
}

@settings = YAML::load(yamlstring)
# puts @settings.inspect

@access_token = @settings['access_token']
Instagram.configure do |config|
  config.client_id = @settings['client_id']
  config.access_token = @access_token
end


# me = Instagram.user('self')
# me = Instagram.user(3080417)
# puts me.id

result = Instagram.tag_search('igerssf')
puts result[0].inspect
result = Instagram.tag_recent_media('igerssf')
puts result[0].inspect
puts result[0].caption.from.username
puts result[0].created_time
puts result[0].id
puts "--------------------------------------------"
# puts Instagram.like_media(result[0].id)


