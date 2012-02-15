#!/usr/bin/env ruby

# get string of letters
# print out permutations that match words in /usr/share/dict/words

if ARGV[0].length > 0
  word = ARGV[0]
end

# perm_len == how long the word is supposed to be
def search_dict(strings)

  # open /usr/share/dict/words
  words = "/usr/share/dict/words"
  words_file = File.open(words, "r")

  words_file.each { |f|
    if f.chop.eql?(strings)
      puts "match for #{f}"
    end
  }
  words_file.close
end

def perm(strings, letters, letters_len, perm_len)
  i = 0
  counter = 0
  test = 0
  for j in 0..letters_len-1
    if strings.length == perm_len
      if (counter == 0)
        search_dict(strings)
        # print "\n"
      end
      counter = counter + 1
    else
      if strings.length == (perm_len - 1)
        # print strings
        # print letters[j]
      end
      perm(strings + letters[j], letters, letters_len, perm_len)
    end
  end
end

letters = Array.new
letters = word.split(//)
puts letters.count

perm("", letters, letters.count, letters.count)

