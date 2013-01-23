#!/usr/bin/env ruby

results = %x[ec2-describe-instances --region us-west-1   | grep Name  | grep app | awk {'print $3'}]

a_list = results.split(/\n/)

a_list.each do |server|
  res = %x[ec2-describe-instances --region us-west-1 | grep #{server} | grep INSTANCE | awk {'print $15'}]
  puts res
end
