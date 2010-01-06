#!/usr/bin/env ruby


def quicksort(a)
  return a if a.size <= 1
  p = a[0] # pivot element
  quicksort(a.select {|i| i < p }) + a.select {|i| i == p} + quicksort(a.select {|i| i > p })
end


def randomizedlist(size)
  list       = []
  randomlist = []
  (1..size).each do |i|
    list.push(i)
  end

  while list.size > 0
    pivot       = rand(list.size)
    tmp         = list[0]
    list[0]     = list[pivot] 
    list[pivot] = tmp
    out         = list.shift
    randomlist.push(out) 
  end
  return randomlist
end

a = Time.now.to_f
rlist = randomizedlist(40000)
b = Time.now.to_f
print "randomized list generated in "
p(b - a)
quicksort(rlist)
c = Time.now.to_f
print "items sorted in "
p(c - b)
