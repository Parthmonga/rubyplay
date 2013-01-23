#!/usr/bin/env ruby

results = %x[ec2-describe-instances --region us-west-1   | grep Name  | grep app | awk {'print $3'}]

a_list = results.split(/\n/)

i = 1
puts "global
    daemon
    maxconn 256

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend http-in
    bind *:80
    default_backend neo4j

backend neo4j"

a_list.each do |server|
  # internal ip
  # res = %x[ec2-describe-instances --region us-west-1 | grep #{server} | grep INSTANCE | awk {'print $15'}].chomp
  # external ip
  res = %x[ec2-describe-instances --region us-west-1 | grep #{server} | grep INSTANCE | awk {'print $14'}].chomp
  puts "    server s#{i} #{res}:80  maxconn 32"
  i += 1
end

puts "

listen admin
    bind *:8080
    stats enable
"
