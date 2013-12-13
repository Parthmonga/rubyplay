#!/usr/bin/env ruby

require 'rubygems'

fh = File.open("by_city_addresses.txt","r")
fh.each do |line|

  a = line.split(/:/)
  city = a[0]
  addr = a[1]
  results = %x[../geo_listing.rb "#{a[1]}"].chomp
  puts "#{a[0]},#{results},100"
end
fh.close
