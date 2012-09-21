#!/usr/bin/env ruby

require 'rubygems'
require 'curb'

class Users
  attr_accessor :twitter

end

def bool_status(status)
  if status =~ /404/
    raise Error, '404 Error'
  end
end

twitters = %w[barce fembotn d7d8d7d8 drdresay]

twitters.each { |t| 
  begin
    c = Curl::Easy.perform("http://twitter.com/#{t}/")
    puts c.status
    bool_status(c.status)
    sleep 1
  rescue 
    puts 'failed'
  end
}
