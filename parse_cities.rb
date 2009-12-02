#!/usr/bin/env ruby



require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'rexml/document'
require 'optparse'

URL_MAIN = 'http://www.gaycities.com/'

# get cities and urls
# parse: <ul class="special">(.*)</ul>

# get the categories for a city
# tabs.*tabs

class City
  attr_accessor :name, :country, :url


end

class Locale
  attr_accessor :name, :description, :neighborhood, :city, :state, :zip, :category
end

class Parser
  attr_accessor :url, :data, :final_cities
    
  def results
    @data = Net::HTTP.get_response(URI.parse(@url)).body
  end
  
  def getCityUrls
    city_urls     = @data.scan(/http:\/\/(.*?)\.gaycities\.com/six)
    sorted_cities = city_urls.sort.uniq
    # puts sorted_cities
    @final_cities = []
    sorted_cities.each {
      |city| @final_cities << include_city(city)
    }
    return final_cities
  end
  
  def getCityData
    @final_cities.each { |city | 
      puts city.to_s
    }
  
  end
end

def include_city(city)

  if city.to_s == 'www'
    return false
  end
  if city.to_s == 'biz'
    return false
  end
  if city.to_s == 'signin'
    return false
  end
  if city.to_s =~ /.*twitter.*/
    return false
  end
  if city.to_s =~ /.*facebook.*/
    return false
  end
  return city
end

test = Parser.new
test.url = URL_MAIN
test.results
test.getCityUrls
test.getCityData

