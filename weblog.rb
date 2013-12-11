#!/usr/bin/env ruby

h_stats = Hash.new
ip_stats = Hash.new
ua_stats = Hash.new
fh = File.open("#{ENV['HOME']}/pr.log")


fh.each do |line|

  if line =~ /url:(.*?)\-\]/
    if h_stats[$1].nil?
      h_stats[$1] = 1
    else
      h_stats[$1] = h_stats[$1] + 1
    end
  end

  if line =~ /ip:(.*?)\-\]/
    if ip_stats[$1].nil?
      ip_stats[$1] = 1
    else
      ip_stats[$1] = ip_stats[$1] + 1
    end
  end

  if line =~ /ua:(.*?)\-\]/
    if ua_stats[$1].nil?
      ua_stats[$1] = 1
    else
      ua_stats[$1] = ua_stats[$1] + 1
    end
  end

end


fh.close

# h_stats.each do |k,v|
#   puts "#{v}: #{k}"
# end

ip_stats.each do |k,v|
   puts "#{v}: #{k}"
end

# ua_stats.each do |k,v|
#   puts "#{v}: #{k}"
# end
