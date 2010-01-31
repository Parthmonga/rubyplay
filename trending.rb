#!/usr/bin/env ruby

require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'optparse'
require 'json'
require 'memcache'

def parse_daily



end 

mc = MemCache::new '127.0.0.1:11211',
                       :debug => true,
                       :c_threshold => 100_000,
                       :compression => false,
                       :namespace => 'foo'
@url = 'http://search.twitter.com/trends.json'

if mc.get("json_trend_data").nil?
	@json_trend_data = Net::HTTP.get_response(URI.parse(@url)).body
	@header          = Net::HTTP.get_response(URI.parse(@url)).header
	mc.set("json_trend_data", @json_trend_data, 100)
	puts "setting memcache"
else
	@json_trend_data = mc.get("json_trend_data")
	puts "getting from memcache"
end


result = JSON.parse(@json_trend_data)
# puts result.inspect
result["trends"].each { |stuff|
	# puts stuff.inspect
}

DAILY = './daily.json'
File.open(DAILY, 'r') do |aFile|
	aFile.each_line { |line| @json_daily_data = line.chomp }
end

result = JSON.parse(@json_daily_data)

result["trends"].each { |stuff|
	parse_daily(stuff)
}
