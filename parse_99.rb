#!/usr/bin/env ruby



require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'rexml/document'
require 'optparse'

URL_MAIN = 'http://www.laweekly.com/2010-11-11/eat-drink/a-movable-beast-l-a-weekly-s-99-essential-restaurants/'

# http://www.laweekly.com/2010-11-11/eat-drink/a-movable-beast-l-a-weekly-s-99-essential-restaurants/24/

# http://hatfieldsrestaurant.com/
# http://dragocentro.com/contactus.php
# http://angelicaffe.com/menu/

class Restaurant
  attr_accessor :name, :address, :phone, :url, :info
end

class Parser
  attr_accessor :url, :data, :final_cities
    
  def results
    @data = Net::HTTP.get_response(URI.parse(@url)).body
  end
  
  def getRestaurantUrls
    24.times do 
    return final_cities
  end
  
  def getCityData
    @final_cities.each { |city| 
      puts city.to_s
    }
  end
end


test = Parser.new
test.url = URL_MAIN
test.results
test.getCityUrls
test.getCityData

