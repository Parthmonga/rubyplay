#!/usr/bin/ruby

require 'rubygems'
require 'soap/wsdlDriver'
require 'pp'
require 'aws/s3'

LDAP_URI_FILE   = "./ldap_uri.txt"
ACCESS_KEY_FILE = "./access_key_s3.txt"
SECRET_FILE     = "./secret_s3.txt"


class S3connection
	attr_accessor :access_key_id, :secret_access_key
	def initialize()
		File.open(ACCESS_KEY_FILE, 'r') do |aFile|
			aFile.each_line { |line| @@access_key_id = line.chomp }
		end
		File.open(SECRET_FILE, 'r') do |aFile|
			aFile.each_line { |line| @@secret_access_key= line.chomp }
		end
	end

	def get_key
		return @@access_key_id
	end

	def get_secret
		return @@secret_access_key
	end
end


class ADUser
	attr_accessor :emailaddress, :password, :role, :wdsl, :isAuth

	def initialize(emailaddress , password)
		File.open(LDAP_URI_FILE, 'r') do |aFile|
			aFile.each_line { |line| @mldap_uri = line.chomp }
		end
		@wdsl = SOAP::WSDLDriverFactory.new(@mldap_uri)
		@emailaddress = emailaddress
		@password     = password
	end

	def authenticate
		soap = @wdsl.create_rpc_driver
		response = soap.AuthenticateUser(
			:emailaddress => @emailaddress,
			:password     => @password,
			:admins       => 'mccann\Wordpress Global Admins',
			:editors      => '',
			:authors      => '',
			:contributors => '',
			:subscribers  => ''
		)
		soap.reset_stream
		
		
		@isAuth = response.isAuthenticated
		@role   = response.role
	end
end # end class

barce = ADUser.new('jim.barcelona@mccann.com','password')
barce.authenticate
puts barce.inspect

if barce.isAuth == true

	s3c = S3connection.new()
	AWS::S3::Base.establish_connection!(
    	:access_key_id     => s3c.get_key(),
    	:secret_access_key => s3c.get_secret()
  	)

	AWS::S3::Service.buckets.each { |i| print i.name + "\n" }
else

	puts "Not authorized to view"

end

