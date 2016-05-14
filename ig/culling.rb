#!/usr/bin/env ruby

require "rubygems"
require "instagram"
require "yaml"
require "net/http"
require "uri"
require "twitter_oauth"
require 'digest/md5'
require "json"
require "active_record"


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


@users_list = Array.new

def get_followers(user_id)
  followers = 0
  sent = "https://api.instagram.com/v1/users/" + user_id.to_s + "/followed-by?access_token=" + @access_token + "&client_id=" + @settings['client_id'] + "&count=100"

  i_sentinel = 1
  followers_list = Array.new

  while i_sentinel > 0 do
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
    sent = result["pagination"]["next_url"]
    puts result["pagination"]["next_cursor"]
    result["data"].each do |user|
      puts user.inspect
      begin
        follower = Instagram.user(user["id"])

        puts "#{follower.counts.follows.to_f} / #{follower.counts.followed_by}"

        ratio = follower.counts.follows.to_f / follower.counts.followed_by
        
        puts ratio
        puts "block: #{ratio}: #{user["username"]}: #{follower.counts.follows} / #{follower.counts.followed_by}" if ratio > 3 
          
      rescue => e
        puts "failed on #{user['username']}: #{user['id']}"
      end
      # user["id"]
      # user["username"]
      # user["bio"]
      followers = followers + 1
    end

    if result["pagination"]["next_cursor"].nil?
      i_sentinel = 0
    end
    irand = rand(6)
    puts "sleeping for #{irand}"
    sleep irand
  end # while loop
  followers
end




me = Instagram.user('self')
# me = Instagram.user(3080417)
puts me.id
puts me.inspect
puts me.counts

puts me.counts.followed_by
puts me.counts.follows

# puts Instagram.user_search("jeffreydgerson")
# a = Instagram.user_follows(5934682, {:count => 50, :cursor => nil})
# puts a.inspect
# puts a['pagination']['next_cursor']
# i = 1
# a.each do |u|
#   puts "#{i}: #{u.inspect}"
#   i = i + 1
# end

# puts Instagram.location_search("37.7808851","-122.3948632")
followers = get_followers(me.id)
# followings = get_followings(me.id)


# get_followers(282741) #mayhemstudios
# get_followers(375151762) #
# get_followers(me.id)

# get_followers(417418840) # thesamgraves



