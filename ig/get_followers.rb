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
# All methods require authentication (either by client ID or access token).
# To get your Instagram OAuth credentials, register an app at http://instagr.am/oauth/client/register/
Instagram.configure do |config|
  config.client_id = @settings['client_id']
  config.access_token = @access_token
end


class User
  attr_accessor :id, :username, :bio
end

me = Instagram.user('self')
puts me.id

@users_list = Array.new

def get_followers(user_id)
  sent = "https://api.instagram.com/v1/users/" + user_id + "/followed-by?access_token=" + @access_token + "&client_id=" + @settings['client_id']
  puts sent

  uri = URI.parse(sent)
  # args = {include_entities: 0, include_rts: 0, screen_name: 'johndoe', count: 2, trim_user: 1}
  # uri.query = URI.encode_www_form(args)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(uri.request_uri)

  response = http.request(request)
  json_data = response.body

  result = JSON.parse(json_data)
  puts result["pagination"]
  result["data"].each do |user|

    u = User.new
    u.id = user["id"]
    u.username = user["username"]
    u.bio = user["bio"]

    @users_list << u
  end
end

get_followers(me.id)


puts @users_list.inspect
# page_1 = Instagram.user_recent_media(777)
# page_2_max_id = page_1.pagination.next_max_id
# page_2 = Instagram.user_recent_media(777, :max_id => page_2_max_id ) unless page_2_max_id.nil?
