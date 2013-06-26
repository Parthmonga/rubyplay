#!/usr/bin/env ruby


require "rubygems"
require "redis"
require "yaml"
require "net/http"
require "uri"
require 'digest/md5'
require "json"
require 'open-uri'
require 'aws/s3'



yamlstring = ''
File.open("./auth.yaml", "r") { |f|
  yamlstring = f.read
}

@settings = YAML::load(yamlstring)

redis_db_dir = "/usr/local/var/db/redis/"
redis_logger_db_dir = "/usr/local/var/db/redis/"

begin
  redis = Redis.new
rescue => error
  puts error.inspect
  exit
end

redis.set("test33","a142f576525f22b3d739fe080c4cbfa2")

puts redis.get("test33")


# get RAILS_ENV
rails_env = ''

if ENV['RAILS_ENV'].nil?
  rails_env = 'development'
  server_dir = "/Users/newuser/repos/r1-effects-web"
else
  rails_env = ENV['RAILS_ENV']
  server_dir = "/mnt/" + @settings['project'] + "-#{rails_env}"
end

# get directory for server code repo

# get redis directory for rdb and logger files
# rubber/rubber-redis.yml

yamlstring = ''
File.open("#{server_dir}/config/rubber/rubber-redis.yml", "r") { |f|
  yamlstring = f.read
}
@redis_settings = YAML::load(yamlstring)

yamlstring = ''
File.open("#{server_dir}/config/rubber/rubber-redis_logger.yml", "r") { |f|
  yamlstring = f.read
}
@redis_logger_settings = YAML::load(yamlstring)

puts rails_env
unless rails_env == 'development'
  puts @redis_settings['redis_logger_db_dir']
  puts @redis_logger_settings['redis_logger_db_dir']
  redis_db_dir = @redis_settings['redis_db_dir']
  redis_logger_db_dir = @redis_logger_settings['redis_logger_db_dir']
end

puts redis_db_dir
puts redis_logger_db_dir
