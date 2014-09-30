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


me = Instagram.user('self')
# me = Instagram.user(3080417)
# puts me.id
# puts me.inspect

def study_follows(username)
  begin
    h = Instagram.user_search(username)
    m = Instagram.user(h[0].id)
    # m = Instagram.user(username)
  rescue => details
    puts details.inspect
    return
  end

  if m.counts.follows.to_f > 0
    # really high means exclusive
    # less than 1 means spammy
    douchebag_factor = m.counts.followed_by.to_f / m.counts.follows.to_f
  else
    douchebag_factor = 100000000.0
  end
  puts "#{m.counts.followed_by}:#{m.username}:#{m.counts.follows}:#{douchebag_factor}"

end

fh = File.open('./barce_followers.txt')

fh.each do |line|
  study_follows(line.chomp.gsub(/\s+/, ""))
  puts line.chomp
end

fh.close
