#!/usr/bin/env ruby

require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'optparse'
require 'json'
require 'memcache'
require 'digest/md5'

#   digest = Digest::MD5.hexdigest("Hello World\n")


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

digest = Digest::MD5.hexdigest(query)
puts digest
if mc.get("json_search_data_"+ digest).nil?
	@json_search_data = Net::HTTP.get_response(URI.parse(@url)).body
	@header          = Net::HTTP.get_response(URI.parse(@url)).header
	mc.set("json_search_data_"+ digest, @json_search_data, 30)
	puts "setting memcache"
else
	@json_search_data = mc.get("json_search_data_"+ digest)
	puts "getting from memcache"
end


result = JSON.parse(@json_search_data)
# puts result.inspect 
# items = result{"results"}
# puts result['results'].inspect
result['results'].each { |tweet|
	# puts tweet.inspect
	puts "----[ " + tweet["from_user"]  + " ]----"
	puts tweet["text"] 
	puts "----- " + tweet['created_at'] + " -----"
	puts
}

puts result['next_page']
