#!/usr/bin/env ruby
#
# yelp.rb
# -------------
# date: 09/19/2008
# by:   barce[a t]codebelay.com
# this file calls the yelp search api
#
# usage: yelp.rb <search terms>
# e.g.:  ./yelp.rb chowder 
#
#

require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'optparse'
require 'json'


API_KEY_FILE = '/Users/barce/apikeys/yelp_YWSID.txt'

#
#
# this is the base Yelp class
#
#
class Yelp
  attr_accessor :base, :app_id, :query, :sent, :rawquery, :city, :state
  def initialize(query, city, state)
    File.open(API_KEY_FILE, 'r') do |aFile|
      aFile.each_line { |line| @@app_id = line.chomp }
    end

    @rawquery = query
    # if there are spaces in query then pre-pend and append double quotes
    query  = CGI.escape(query)
    query  = query.sub(/^/, '%22') if query =~ /[+]/
    query  = query.sub(/$/, '%22') if query =~ /[+]/
    @query = query
    @sent = "&ywsid=" + CGI.escape(@@app_id) 
    @city = city
    @state = state
  end
end

def parse_cats(cats)

  cats.each {|category|
    puts category["name"]
  }

end

#
# class: Cityyelp
# --------------
# we're just doing a yelp city search here. 
#
class Cityyelp < Yelp
  def results
    @sent = "http://api.yelp.com/business_review_search?term=" + @query + "&location=" + CGI.escape("#{@city}, #{@state}") + @sent
    puts @sent
    json_data = Net::HTTP.get_response(URI.parse(@sent)).body
    # puts xml_data
    puts
    result = JSON.parse(json_data)
    result.each { |key, value| 
      puts key
      # puts value.inspect
      if key == 'businesses'
        value.each { |business|
          parse_cats(business["categories"])
        }
      end 
    }
  end
end

def output_help
  puts "usage: catsyelp.rb -q 'fish tacos' --city='San Francisco' --state='CA'"
end

opts = OptionParser.new 
OptionParser.new do |o|
  o.on('-q QUERY') { |query| $query = query}
  o.on('-c CITY') { |city| $city = city }
  o.on('-s STATE') { |state| $state= state}
  o.on('-h') { output_help; exit }
  o.parse!
end

p :query => $query, :city => $city, :state => $state

# TO DO - add additional options
            

query = $query
city = $city
state = $state

# let's get results from yelp
Cityyelp.new("#{query}", city, state).results 

