#!/usr/bin/env ruby

require 's3_ldap_client.rb'

barce = ADUser.new('jim.barcelona@mccann.com','PASS', 'mccann\Wordpress Global Admins', 'http://170.200.167.51/WPAuth.asmx?WSDL')
barce.authenticate
puts barce.inspect

puts barce.isAuth

#
# put a more robust ACL here
#
if barce.isAuth == 'true'

   s3c = S3connection.new("./s3.yaml")
	puts s3c.inspect
   AWS::S3::Base.establish_connection!(
      :access_key_id     => s3c.get_key(),
      :secret_access_key => s3c.get_secret()
   )

   AWS::S3::Service.buckets.each { |i| print i.name + "\n" }
else

   puts "Not authorized to view"

end

