#!/usr/bin/env ruby
require 'pg'
require 'date'
# conn = PGconn.new('localhost', 5432, '', '', 'viame_logger','newuser','')
conn = PGconn.new(ENV['LOGGER_HOST'], ENV['LOGGER_PORT'], '', '', ENV['LOGGER_DB'],ENV['LOGGER_USER'],ENV['LOGGER_PASS'])
res = conn.exec('select * from external_api_events order by id desc limit 1') 

res.each { |result|
  puts result.inspect
}


conn.close()
