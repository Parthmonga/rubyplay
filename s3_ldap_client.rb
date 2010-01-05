#!/usr/bin/ruby

require 'rubygems'
require 'soap/wsdlDriver'
require 'pp'
require 'aws/s3'
require 'yaml'

LDAP_URI_FILE   = "./ldap_uri.txt"


class S3connection
	attr_accessor :access_key_id, :secret_access_key, :yaml_file


	# TODO: use yaml
	def initialize(config_file)
		yamlstring = ''
		@@yaml_file = config_file
		File.open(@@yaml_file, "r") { |f| yamlstring = f.read }
		s3config = YAML::load(yamlstring)
		puts s3config.inspect
		@@access_key_id     = s3config["access_key"]
		@@secret_access_key = s3config["secret_key"]
	end

	def get_key
		return @@access_key_id
	end

	def get_secret
		return @@secret_access_key
	end
end


class ADUser
	attr_accessor :emailaddress, :password, :role, :groups, :wdsl, :isAuth

	def initialize(emailaddress, password, group, ldap_uri)
		@mldap_uri = ldap_uri
		@wdsl = SOAP::WSDLDriverFactory.new(@mldap_uri)
		@emailaddress = emailaddress
		@password     = password
		@groups       = group
	end

	def authenticate
		soap = @wdsl.create_rpc_driver
		response = soap.AuthenticateUser(
			:emailaddress => @emailaddress,
			:password     => @password,
			:admins       => @groups,
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

