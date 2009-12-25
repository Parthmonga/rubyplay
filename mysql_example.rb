#!/usr/bin/env ruby

require "rubygems"
require "mysql"
require 'date'
require 'yaml'
require 'net/http'
require 'uri'

yamlstring = ''
File.open("/Users/Jim/rubyplay/settings.yaml", "r") { |f|
    yamlstring = f.read
}
db = YAML::load(yamlstring)
# puts db.inspect


my = Mysql::new(db["host"], db["user"], db["pass"], db["db"])
res = my.query("select * from concurrent_users")
res.each do |row|
	puts row.inspect
end



