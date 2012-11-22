#!/usr/bin/env ruby

def get_users(raw)

  list  = raw.split(/\n/)
  au = Array.new
  list.each do |line|
    a = line.split(/ : /)
    au << a[1]
  end
  au
end

raw_minute = %x[./current_users.rb 1]
mau = get_users(raw_minute)

raw_hour = %x[./current_users.rb 240]
hau = get_users(raw_hour)

total = 0
mau.each { |id|

  total = total + 1 if hau.include?(id)

}

puts "mau: #{total}"
puts "hau: #{hau.count }"
puts "mau/hau: #{ total.to_f / hau.count.to_f }"
