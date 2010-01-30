#!/usr/bin/env ruby

require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'optparse'
require 'json'


TRENDS = './trends.json'
@json_data
File.open(TRENDS, 'r') do |aFile|
	aFile.each_line { |line| @json_data = line.chomp }
end

result = JSON.parse(@json_data)
puts result.inspect
