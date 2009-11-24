#!/usr/bin/ruby

require 'rubygems'
require 'soap/wsdlDriver'
require 'pp'
require 'aws/s3'

LDAP_URI_FILE   = "./ldap_uri.txt"
ACCESS_KEY_FILE = "./access_key_s3.txt"
SECRET_FILE     = "./secret_s3.txt"

class Ldapadconnection 
	attr_accessor :mldap_enabled, :mldap_uri, :mldap_admin_group, :mldap_editor_group, :mldap_author_group, :mldap_contrib_group, :mldap_subscrib_group

	def initialize()
		File.open(LDAP_URI_FILE, 'r') do |aFile|
			aFile.each_line { |line| @@mldap_uri = line.chomp }
		end
	end

	def showuri
		return @@mldap_uri
	end
end

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

ldc = Ldapadconnection.new()
s_uri = ldc.showuri()
puts s_uri
ldc.mldap_enabled = 'true'
puts ldc.mldap_enabled


s3c = S3connection.new()
AWS::S3::Base.establish_connection!(
    :access_key_id     => s3c.get_key(),
    :secret_access_key => s3c.get_secret()
  )

AWS::S3::Service.buckets.each { |i| print i.name + "\n" }
