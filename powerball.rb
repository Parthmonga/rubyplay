#!/usr/bin/env ruby
#

answers = Array.new
tmp = 0
puts "enter 5 picks: "

5.times do |i|
  answers << gets.chomp
end


results = Array.new

5.times do |i|
  results << rand(58) + 1
end

results = results.sort

results << rand(35) + 1

puts results.inspect
