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


begin
  redis = Redis.new
rescue => error
  puts error.inspect
  exit
end

(0..1000).each do |i|
  redis.set("test#{i}",Digest::MD5.hexdigest("test#{i}"))
  puts "test#{i}: #{Digest::MD5.hexdigest("test#{i}")}"
end


