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
require 'mysql2'
require 'date'


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

ActiveRecord::Base.establish_connection(
    :adapter => "mysql2",
    :database => "#{@settings['database']}",
    :username => "#{@settings['username']}",
    :password => "",
    :host => "#{@settings['host']}",
    :port => @settings['port'],
    :pool => 8
)

class User < ActiveRecord::Base
  def instagram
    ig = Instagram.user(instagram_id)
    ig
  end
  
  def retrieve_all_post_dates
    User.all.each do |user|
      recents = []
      begin 
        recents = Instagram.user_recent_media(user.instagram_id)
      rescue => e
        puts e.message
        puts "cannot view recents"
      end
      recents.each do |media|
        puts DateTime.strptime(media.created_time, '%s').in_time_zone('America/Los_Angeles')
        pd = PostDate.new 
        pd.user_id      = user.id
        pd.posted       = DateTime.strptime(media.created_time, '%s').in_time_zone('America/Los_Angeles')
        pd.save!
      end
      counts = counts + 1
      sleep rand(6) if counts % 129 == 0
    end
  end
  
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
        uid = 0
        puts user.inspect
        # {"username"=>"kaylandjp", "profile_picture"=>"https://scontent.cdninstagram.com/t51.2885-19/s150x150/12716616_1052437788173707_1579909207_a.jpg", "id"=>"2911292764", "full_name"=>""}
        begin
          uid = User.find_by_instagram_id(user["id"]).id
        rescue
          puts "could not find #{user.inspect}"
        end
        if uid == 0
          u = User.new
          u.instagram_id    = user["id"]
          u.username        = user["username"]
          u.full_name       = user["full_name"]
          u.profile_picture = user["profile_picture"]
          begin 
            u2  = Instagram.user(user["id"])
            u.bio             = u2.bio
            u.website         = u2.website
            u.followed_by     = u2.counts.followed_by
            u.follows         = u2.counts.follows
            u.media           = u2.counts.media
          rescue => e
            puts e.message
            puts "couldn't get deeper user data for #{user['username']}"
          end
          u.save!
        end
        u2 = nil
        followers = followers + 1
      end

      if result["pagination"]["next_cursor"].nil?
        i_sentinel = 0
      end
      puts "id: #{user_id} followers: #{followers}"
      irand = rand(6)
      puts "sleeping for #{irand}"
      sleep irand
    end # while loop
    followers
  end
  
end


class PostDate < ActiveRecord::Base
end



# u = Instagram.user(2968734636)
# me = Instagram.user('self')

# me = Instagram.user(3080417)
# puts me.id
# puts me.inspect
# puts me.bio
# puts me.counts.follows
# puts me.counts.followed_by
# puts me.counts.media
# 
# counts = 0

# puts User.last.inspect
#
client = Instagram.client(:access_token => @access_token)
puts client.user('self').inspect
# client.user_recent_media.each do |media|
#   puts media.inspect
# end

# flying = Instagram.user_search("flyingthroughfilm")[0]
# puts flying.inspect
# user = User.find_by_instagram_id(flying['id'])
# puts user.instagram

# a = Instagram.user_follows(5934682, {:count => 50, :cursor => nil})
# puts a.inspect
# puts a['pagination']['next_cursor']
# i = 1
# a.each do |u|
#   puts "#{i}: #{u.inspect}"
#   i = i + 1
# end

# puts Instagram.location_search("37.7808851","-122.3948632")
# followers = get_followers(me.id)
# followings = get_followings(me.id)


# get_followers(282741) #mayhemstudios
# get_followers(375151762) #

# get_followers(417418840) # thesamgraves



