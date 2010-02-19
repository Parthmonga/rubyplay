#!/usr/bin/env ruby
#
# chambers_parser.rb
# -------------
# date: 02/17/2010
# by:   barce[a t]codebelay.com
# this file parsers a sample chambers json file
#
# usage: chambers_parser.rb <search terms>
# e.g.:  ./chambers_parser.rb MCA.json.txt
#
#
#
# "Categories"
# "FullDescription"
# "ID"
# "Images"
# "Keywords"
# "Latitude"
# "Longitude"
# "MemberSince"
# "Name"
# "POI_Info"
# "Phone1"
# "Phone2"
# "PhysicalAddress"
# "ShortDescription"
# "WebsiteUrl"
# 


require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'optparse'
require 'json'

def parse_member(member)

  # puts "member: " + member.inspect
  member.each { |key, value|

    # save member to listings
    # save categories
    # save keywords
    # save images

    if key == 'Categories'
      
    end
    if key == 'Keywords'
      # puts value.inspect
    end
    if key == 'Images'
      # puts value.inspect
    end
    if key == 'MemberSince'
      puts value.inspect
    end

  }

end

s_file = ARGV[0]
puts s_file

if s_file.nil?
  s_file = "MCA.json.txt"
end

listfile = File.open(s_file, "r")

json_string = String.new
listfile.each { |line|

  json_string = json_string + line

}

listfile.close
result = JSON.parse(json_string)

# puts result.inspect
result.each { |key, value|

  if key == 'Members'
    @memberlist = value
  else 
    puts "key: " + key.inspect
    # puts "value: " + value.inspect
  end
}

@memberlist.each { |member|

  # puts "member: " + member.inspect
  # puts "----[start]----"
  parse_member(member)
  # puts "----[end]----"

}

