#!/usr/bin/env ruby


unless request.env["HTTP_X_FORWARDED_FOR"].nil?
  @access_token = request.env["HTTP_X_FORWARDED_FOR"]
else 
  @access_token = request.ip.to_s
end

if request.url =~ /client_id=([A-Za-z0-9]+)/
  @access_token = $1
end

if request.url =~ /access_token=([A-Za-z0-9]+)/
  @access_token = $1
end

unless rack.request.form_hash['key'].length.nil?
  @access_token = rack.request.form_hash['key']
end 


puts @access_token
