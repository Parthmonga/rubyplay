#!/usr/bin/env ruby

require 'digest/md5'


puzzle = 'puzzle.txt'

hashes = File.open(puzzle, "r")

hashes.each { |line| 
  puts line
}

