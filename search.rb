#!/usr/bin/env ruby

require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'optparse'
require 'json'
require 'memcache'


query = ARGV.join(" ")
puts "Searching for " + query + "..."
query = CGI.escape(query)
puts "decoding query as " + query

mc = MemCache::new '127.0.0.1:11211',
                       :debug => false,
                       :c_threshold => 100_000,
                       :compression => false,
                       :namespace => 'foo'
@url = 'http://search.twitter.com/search.json?q=' + query.to_s
puts @url

if mc.get("json_search_data").nil?
	@json_search_data = Net::HTTP.get_response(URI.parse(@url)).body
	@header          = Net::HTTP.get_response(URI.parse(@url)).header
	mc.set("json_search_data", @json_search_data, 100)
	puts "setting memcache"
else
	@json_search_data = mc.get("json_search_data")
	puts "getting from memcache"
end


result = JSON.parse(@json_search_data)
items = result["results"]
items.each { |tweet|
	puts stuff["name"] + "\t" + stuff["url"]

}
