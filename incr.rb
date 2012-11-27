def foo (n) lambda {|i| n += i } end

bar = foo 1

puts bar.call 5
puts bar.call 9
puts bar.call 16

