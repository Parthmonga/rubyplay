#!/usr/bin/env ruby

PATH = '/Users/Jim/botters/'
logs = Array.new
logs = %w(w2_access_log	w3_access_log-20091220 w1_access_log w2_access_log-20091220 w1_access_log-20091220 w3_access_log)

fullogs = []
puts "Botbeagle"
puts

logs.each { |logfile| fullogs.push(PATH + logfile) }

fullogs.each { |logfile| puts logfile }
