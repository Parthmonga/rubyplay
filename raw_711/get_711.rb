#!/usr/bin/env ruby


require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'optparse'
require 'json'


# curl -H "Content-Type: text/json" -X POST -d '{"Filters":[],"SearchRangeMiles":"15","PageNumber":"0","PageSize":5,"SourceLatitude":37.77711868286133,"SourceLongitude":-122.41963958740234}'  https://www.7-eleven.com/api/location/searchstores


def parse_list(raw)

  s_address = ''
  js = JSON.parse(raw)
  js.each do |store|
    if store['Address2'].nil?
      s_address = "#{store['Address1']}, #{store['City']}, #{store['State']} #{store['Zip']}"
    else
      s_address = "#{store['Address1']}, #{store['Address2']}, #{store['City']}, #{store['State']} #{store['Zip']}"
    end
    puts s_address
    fw = File.open("./addresses.txt", "a")
    fw.write("#{s_address}\n")
    fw.close
  end
end

def get_stores(lat,long)

  # lat  = 37.77711868286133 if lat.nil? or lat == 0
  # long = -122.41963958740234 if long.nil? or lat == 0
  i    = 0
  puts "#{lat},#{long}"

  begin 
    results = %x[curl -H "Content-Type: text/json" -X POST -d '{"Filters":[],"SearchRangeMiles":"15","PageNumber":"#{i}","PageSize":5,"SourceLatitude":#{lat},"SourceLongitude":#{long}}'  https://www.7-eleven.com/api/location/searchstores]
    pagesize = 5.0

    js = JSON.parse(results)
    puts js.count
    total = js[0]['TotalResultCount']
    pages = (total / pagesize).floor
    # pages = 0
    # get page results
    
    (0..pages).each do |i| 
      puts "page: #{i}"
      results = %x[curl -H "Content-Type: text/json" -X POST -d '{"Filters":[],"SearchRangeMiles":"15","PageNumber":"#{i}","PageSize":5,"SourceLatitude":#{lat},"SourceLongitude":#{long}}'  https://www.7-eleven.com/api/location/searchstores]
      parse_list(results)
    end
  rescue => e
    puts e.inspect
  end
  

end

get_stores(37.77711868286133,-122.41963958740234)
fh = File.open("sorted_cities_ll.txt", "r")

fh.each do |ll|
  a_lat_long = ll.split(/,/)
  get_stores(a_lat_long[0],a_lat_long[1])
  sleep 1
end

fh.close
