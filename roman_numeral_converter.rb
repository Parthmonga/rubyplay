#!/usr/bin/env ruby

# I = 1
# V = 5
# X = 10
# L = 50
# C = 100
# D = 500
# M = 1000


class Roman
  attr_accessor :numeral, :digits

  def initialize()
    self.digits = 0
  end

  def to_decimal
    a_numeral = Array.new
    basics = Hash.new
    i = 0

    basics['I'] = 1
    basics['V'] = 5
    basics['X'] = 10
    basics['L'] = 50
    basics['C'] = 100
    basics['D'] = 500
    basics['M'] = 1000

    a_numeral = self.numeral.split(//)

    i = 0
    i_sentinel = 0

    while i_sentinel < 1
      if i > a_numeral.size
	i_sentinel = 1
      end 
      unless basics[a_numeral[i+1]].nil?
        if basics[a_numeral[i]] < basics[a_numeral[i+1]]
	  self.digits = self.digits + (basics[a_numeral[i+1]] - basics[a_numeral[i]])
	  i = i + 1
        else 
  	  self.digits = self.digits + basics[a_numeral[i]]
        end 
      end
      i = i + 1
    end
    self.digits
  end
end

s = Roman.new
s.numeral = 'MCMLXXXIX'
puts s.numeral
puts s.to_decimal
