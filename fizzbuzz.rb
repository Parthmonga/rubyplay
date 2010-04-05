#!/usr/bin/env ruby


loops = 100

loops.times do |i|

  print i.to_s + " "
  if ( ( (i % 3) == 0 ) && ( (i % 5) == 0 ) )
    puts 'fizzbuzz'
  elsif (i % 3) == 0
    puts 'fizz'
  elsif (i % 5) == 0
    puts 'buzz'
  end
  puts

end
