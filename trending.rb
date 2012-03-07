#!/usr/bin/env ruby

require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'optparse'
require 'json'
require 'memcache'

def parse_trend(item)
	item.each { |query|
		puts "\t" + query["name"]
	}
end

def parse_daily(stuff)

	stuff.each { |item|
		if item.is_a?(String)
			puts item
		else
			parse_trend(item)
		end
	}

end 

mc = MemCache::new '127.0.0.1:11211',
                       :debug => false,
                       :c_threshold => 100_000,
                       :compression => false,
                       :namespace => 'foo'

# 2487956 == 'san francisco' woeid
# 1 == US woeid
@url = 'http://api.twitter.com/1/trends/2487956.json'

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
# puts result[0]["trends"]
result[0]["trends"].each { |stuff|
	puts stuff["name"] + "\t" + stuff["url"]
}

