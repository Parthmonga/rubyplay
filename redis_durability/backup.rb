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


# copy files to s3

def s3_db_upload(db_file, db_path, rails_env)

  begin
    AWS::S3::Base.establish_connection!(
      :access_key_id     => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    )
  
    AWS::S3::S3Object.store(db_file, open(db_path), "#{@settings['bucket']}/#{rails_env}", :access => :public_read)
  rescue => error
    puts "upload failed to s3 for #{db_file}, #{db_path}, #{rails_env}"
    puts error.inspect
    exit
  end
  puts "uploaded to http://#{@settings['bucket']}.s3.amazonaws.com/#{rails_env}/#{db_file}"


end

s3_db_upload("dump.rdb",redis_db_dir + "dump.rdb", rails_env)

s3_db_upload("appendonly.aof",redis_db_dir + "appendonly.aof", rails_env)


s3_db_upload("dump_logger.rdb",redis_logger_db_dir + "dump_logger.rdb", rails_env)


s3_db_upload("appendonly_logger.aof",redis_logger_db_dir + "appendonly_logger.aof", rails_env)

