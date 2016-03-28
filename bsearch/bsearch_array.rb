#!/usr/bin/env ruby

# Binary search solves the problem [of searching within a pre-sorted array] by 
# keeping track of a range within the array in which T [i.e. the sought value] 
# must be if it is anywhere in the array.  Initially, the range is the entire 
# array.  The range is shrunk by comparing its middle element to T and 
# discarding half the range.  The process continues until T is discovered in 
# the array, or until the range in which it must lie is known to be empty.  
# In an N-element table, the search uses roughly log(2) N comparisons.

def bsearch(needle,haystack)
  pivot = haystack.size / 2
  puts "pivot: #{pivot}"
  if haystack[pivot] != needle && haystack.size > 2
    puts haystack.inspect
    if needle < haystack[pivot]
      puts 'recurse less than'
      bsearch(needle, haystack.slice(0..pivot)) 
    end 
    if needle > haystack[pivot]
      puts 'recurse greater than'
      bsearch(needle, haystack.slice(pivot..haystack.size))
    end
  else 
    if haystack[pivot] == needle
      puts "found: #{haystack[pivot]}"
    else
      puts "found: #{haystack[pivot - 1] }"
    end
  end
end

# Let the pre-sorted array be: 
# [23, 68, 99, 250, 342, 554, 777, 1009, 1020, 3452]
haystack = [7, 16, 23, 68, 99, 250, 251, 289, 300, 342, 554, 777, 1009, 1020, 3452, 7854]
needle   = 1009



puts bsearch(needle,haystack)


