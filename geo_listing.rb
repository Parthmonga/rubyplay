#!/usr/bin/env ruby
#
# geo_listing.rb
# ---------------
# by:   barce[a t]radiumone.com
#
# usage: geo_listing.rb "address"
#

require 'rubygems'
require 'geokit'
include Geokit::Geocoders


# try without zip if broken
full_address = ARGV[0]


def do_geo(address)
  # set latitude and longitude
  Geokit::Geocoders::request_timeout = 0
  Geokit::Geocoders::google = ENV['GOOGLE_GEOKIT_API_KEY']

  
  res=Geokit::Geocoders::Google3Geocoder.geocode("#{address}")
  lat_long = Array.new
  puts res.ll
  f_lat = 0.00
  f_long = 0.00
  if res.ll.to_s.length <= 1
  
    puts "cannot geolocate: #{address}"
    f = File.open("_json/error.txt", "w")
    f.write("cannot geolocate: #{address}")
    f.close
  
  end

end # end def

do_geo(full_address)


   

