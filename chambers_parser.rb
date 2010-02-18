#!/usr/bin/env ruby
#
# chambers_parser.rb
# -------------
# date: 02/17/2010
# by:   barce[a t]codebelay.com
# this file parsers a sample chambers json file
#
# usage: chambers_parser.rb <search terms>
# e.g.:  ./chambers_parser.rb MCA.json.txt
#
#

require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'optparse'
require 'json'


s_file = ARGV[0]
puts s_file

# result = JSON.parse(json_data)



