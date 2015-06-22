#!/usr/bin/env ruby
#
#

a = [98332,52343,77723]
h = Hash[a.map.with_index.to_a]

# rules
# if a is size 1, then it compares itself to itself.
# if a is size 1+n, then it compares itself to itself, and anything before it.
# e.g.
# a = [1]
# {"1":{"1":{"count":"0"}}}
# a = [1,2]
# {"1":{"1":{"count":"0"}},"2":{"1":{"count":"0"},"2":{"count":"0"}}}
# a = [1,2,3]
# {"1":{"1":{"count":"0"}},"2":{"1":{"count":"0"},"2":{"count":"0"}},"3":{"1":{"count":"0"},"2":{"count":"0"},"3":{"count":"0"}}}

def do_iter current, key, list
  str = "\"#{current}\":"
  (0..key).each do |i|
    if 0 == key
      str = str + "{\"#{list[i]}\":{\"count\":\"0\"}"
    end
    if key > 0
      if i == key
        str = str + "{\"#{list[i]}\":{\"count\":\"0\"}"
      else
        str = str + "{\"#{list[i]}\":{\"count\":\"0\"},"
      end
    end
  end
  str = str + "}"

  str
end

str = "{"
counter = 1
a.each do |i|
  str = str + (do_iter i, h[i], a)
  str = str + "," unless counter == a.size
  counter = counter + 1
end
str = str + "}"
print str
