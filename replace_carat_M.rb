#!/usr/bin/env ruby

require "rubygems"
require "mysql2"
require 'date'
require 'yaml'
require 'net/http'
require 'uri'
require "stringio"

yamlstring = ''
File.open("./settings.yaml", "r") { |f|
    yamlstring = f.read
}
db = YAML::load(yamlstring)
# puts db.inspect


a_ids = Array.new





client = Mysql2::Client.new(:host => db['host'], :username => db['user'], :database => db['db'], :password => db['pass'])
sql = "select id, segment_definition from slice_definition where segment_definition like '%\r%'"

res = client.query(sql)
res.each do |row|
  puts row['id']

  client2 = Mysql2::Client.new(:host => db['host'], :username => db['user'], :database => db['db'], :password => db['pass'])

  segment_definition = row['segment_definition']
  segment_definition.delete("\r")
  segment_definition.delete("^M")
  segment_definition.gsub! "\r", ""
  segment_definition.gsub! "^M", ""
  segment_definition.gsub! "\\n", "\n"

  escaped = client2.escape(segment_definition)

  puts escaped
  usql = "update slice_definition set segment_definition = '#{escaped}' where id = #{row['id']}"
  results = client2.query(usql)
  puts results.inspect
  client2.close
end

client.close
