#!/usr/bin/env ruby
require 'pg'
require 'date'
conn = PGconn.new('localhost', 5432, '', '', 'viame_logger','newuser','')
res = conn.exec('select * from backfill')

res.each { |result|

  # puts result.inspect
  d = DateTime.parse(result['created_at'])
  created_at = (d+2).strftime('%Y-%m-%d %H:%M:%S +0000')
  d = DateTime.parse(result['updated_at'])
  updated_at = (d+2).strftime('%Y-%m-%d %H:%M:%S +0000')
  d = Date.parse(result['received_at'])
  received_at = (d+2).to_s

  puts "insert into external_api_events (client_id,  hostname, ip, heaptotal, heapused, loadaverage, uptime, path, created_at, updated_at, received_at, event, load_one, load_five, load_fifteen) values ('#{result['client_id']}', '#{result['hostname']}', '#{result['ip']}', #{result['heaptotal']}, #{result['heapused']}, '#{result['loadaverage']}', #{result['uptime']}, '#{result['path']}', '#{created_at}', '#{updated_at}', '#{received_at}', '#{result['event']}', #{result['load_one']}, #{result['load_five']}, #{result['load_fifteen']});"


}

# d.strftime('%Y-%m-%d %H:%M:%S +0000')
# {"id"=>"10089394", "client_id"=>"undefined", "access_token"=>nil, "hostname"=>"6707b821-e7a6-4432-8ab4-ae1e8f6cb1c1", "ip"=>"10.102.11.176", "event_id"=>nil, "tag"=>nil, "rss"=>nil, "heaptotal"=>"9313344", "heapused"=>"7547352", "loadaverage"=>"[\"8.263671875\", \"9.63623046875\", \"11.41015625\"]", "uptime"=>"252108.62214555", "freemem"=>nil, "totalmem"=>nil, "path"=>"%2Fv1%2Fupload", "created_at"=>"2012-09-07 17:10:42.594028", "updated_at"=>"2012-09-07 17:10:42.594028", "received_at"=>"2012-09-07", "event"=>"app.post", "load_one"=>"8.263671875", "load_five"=>"9.63623046875", "load_fifteen"=>"11.41015625"}

