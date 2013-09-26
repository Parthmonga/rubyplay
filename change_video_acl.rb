#!/usr/bin/env ruby
require 'pg'
require 'date'
conn = PGconn.new('HOST', PORT, '', '', 'DB','USER','')
res = conn.exec('select original_media_url from posts where zencoder_video_id > 0 limit 5')

res.each { |result|

  # puts result.inspect
  puts result['original_media_url']


}


