#!/usr/bin/ruby

require 'rubygems'
require 'cassandra'
include SimpleUUID

# twitter = Cassandra.new('Twitter', ['192.168.0.103:9160', '192.168.0.109:9160'])
twitter = Cassandra.new('Twitter', ['192.168.0.103:9160'])
# twitter = Cassandra.new('Twitter', ['192.168.0.109:9160'])
# twitter.insert(:Users, "5", {'screen_name' => "buttonscat"})
# twitter.insert(:Users, "6", {'screen_name' => "barce"})
# twitter.insert(:Users, "7", {'screen_name' => "johnz"})
twitter.insert(:Users, "8", {'login' => "crazy8", 'pass' => 'flakyflaky'})
# twitter.remove(:Users, "8")
# twitter.delete(:Users, "8")
# puts twitter.inspect

# puts twitter.get(:Users, '5')
