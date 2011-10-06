#!/usr/bin/env ruby

def count_commas(line)

  a = line.split(',')
  a.size

end

csv = '/Users/jimbarcelona/sinatra/test-tools/resistance3-resourceapp/template/nil.csv'

a = Array.new
fh = File.open(csv, "r")
fh.each { |line|
  a << count_commas(line)

}
fh.close

if a[0] == a[1]
  puts "template is correct with #{a[0]} items per row."
else
  puts "template is incorrect with"
  puts "#{a[0]} items in one row and"
  puts "#{a[1]} items in another row."
end

