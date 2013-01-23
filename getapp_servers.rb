#!/usr/bin/env ruby

results = %x[ec2-describe-instances --region us-west-1   | grep Name  | grep app | awk {'print $3'}]

a_list = results.split(/\n/)

i = 0
a_list.each do |server|
  puts "#{i}: #{server}"
  res = %x[ec2-describe-instances --region us-west-1 | grep #{server} | grep INSTANCE | awk {'print $15'}]
  puts res
  i += 1
end
exit
results.each do |server|
  # res = %x[ec2-describe-instances --region us-west-1 | grep #{server} | grep INSTANCE | awk {'print $15'}]
  # puts res
  puts "(#{server})"
end
