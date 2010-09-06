#
#
# this program generates
# a random dictionary password
# based on /usr/share/dict/words
# 

def genpass
@dict = '/usr/share/dict/words'

words = []

File.open(@dict, 'r') do |aFile|
	aFile.each_line { |line| words.push(line.chomp) }
end

# puts words.size.to_s
first = 2344
while (words[first].to_s.length > 6) 
	first = rand(words.size)
	# puts words[first].to_s
	words[first].to_s
end 

second = 2344
while (words[second].to_s.length > 6) 
	second = rand(words.size)
	# puts words[second].to_s
	words[second].to_s
end 
num    = rand(99)

return words[first] + num.to_s + words[second]

end

