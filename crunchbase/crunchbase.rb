#!/usr/bin/env ruby
#
# crunchbase.rb
# -------------
# by:   barce[a t]codebelay.com
# this file calls the crunchbase api
#
#
#

require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'optparse'
require 'json'

def output_help
  puts "usage: crunchbase.rb -q "
end


opts = OptionParser.new 
OptionParser.new do |o|
  o.on('-q QUERY') { |query| $query = query}
  o.on('-h') { output_help; exit }
  o.parse!
end


query = $query

puts "(#{query})"

@sent = "http://api.crunchbase.com/v/1/company/" + query + ".js"
puts "(#{@sent})"
json_data = Net::HTTP.get_response(URI.parse(@sent)).body
result = JSON.parse(json_data)
result.each { |key, value| 
  puts "key: #{key}"
  puts "value: #{value.inspect}"

}
