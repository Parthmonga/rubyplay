#!/usr/bin/ruby

require 'rubygems'
require 'cassandra'
include SimpleUUID

# twitter = Cassandra.new('Twitter', ['192.168.0.103:9160', '192.168.0.109:9160'])
twitter = Cassandra.new('Twitter', ['192.168.0.103:9160'])
puts twitter.get(:Users, '8').inspect
twitter = Cassandra.new('Twitter', ['192.168.0.109:9160'])
puts twitter.get(:Users, '8').inspect
# twitter.insert(:Users, "5", {'screen_name' => "buttonscat"})


