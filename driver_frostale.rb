#!/usr/bin/env ruby

require 'rubygems'
require 'soap/wsdlDriver'
require 'frostale'


user = Frostale.new('user@example.com','pass', 
  'domain\group Global Admins',
  'http://127.0.0.1/WPAuth.asmx?WSDL')
# user.authenticate
# puts "authenticated" if user.isAuth == 'true'

