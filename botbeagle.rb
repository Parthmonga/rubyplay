#!/usr/bin/env ruby

require "rubygems"
require "mysql"
require 'date'
require 'yaml'
require 'net/http'
require 'uri'

def prhash(hashlist)
  byValue = Array.new
  hashlist.each do |key, value|
    # puts key.to_s + " " + value.to_s
    if value > 100
      byValue.push(value.to_s + " " + key.to_s)
    end
  end
  
  byValue.sort.each { |bval| puts bval }
end

def parse_log(logfile)

  puts logfile
  listfile = File.open(logfile, "r")
  ips = {}
  tmp = Array.new
  listfile.each { |line|
    
    # grep for:
    # wp-postratings.php?pid=
    # puts line
    tmp = line.scan(/^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*postratings\.php\?pid=([0-9]+)/)
    unless tmp.empty?
     ips[$1] = ips[$1].to_i + 1
    
    end
    tmp = ()
    
  }
  #prhash(ips)
  return ips
end

PATH = '/Users/Jim/botters/'
logs = Array.new
# logs = %w(w2_access_log	w3_access_log-20091220 w1_access_log w2_access_log-20091220 w1_access_log-20091220 w3_access_log)
# logs = %w(w2_access_log)
logs = %w(all_log.txt)

fullogs = []
puts "Botbeagle"
puts

logs.each { |logfile| fullogs.push(PATH + logfile) }

@ips = {}
fullogs.each { |logfile| 
  
  @ips = parse_log(logfile)
   
}
prhash(@ips)

