#!/usr/bin/env ruby

require 'digest/md5'


puzzle = 'puzzle2.txt'
words  = '/usr/share/dict/words'



def crack(line)
  line.chop!
  i_cracked = 0
  # puts "cracking"
  crack_file = File.open("lessthan6.txt", "r")
  crack_file.each { |word|
    word2 = word.chop! 
    # puts "--"
    # puts "(#{word2})"
    # puts "(#{Digest::MD5.hexdigest(word2)})"
    # puts "(#{line})"
    if Digest::MD5.hexdigest(word2) == line
      puts "#{word}"
      i_cracked = 1
    end
    # puts "--"
  }
  crack_file.close
  return i_cracked
end


if !File.exist?("lessthan6.txt")
  puts "creating lessthan6.txt"
  less = File.open("lessthan6.txt", "w")
  words_file = File.open(words, "r")

  words_file.each { |word|
    if word.length < 10
      less.write(word)      
    end
  }
  words_file.close
  less.close
end


hashes = File.open(puzzle, "r")

hashes.each { |line| 
  # puts line
  i_cracked = crack(line)
  if i_cracked == 0
    puts "could not crack #{line}"
  end
}

hashes.close
