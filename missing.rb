#!/usr/bin/env ruby

require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'optparse'
require 'json'
require 'digest/md5'

#   digest = Digest::MD5.hexdigest("Hello World\n")


def missing_category(aff_id)
    # params[:OrganizationId]
    @url = 'http://m.mychamberapp.com/chamber/missing_category/' + aff_id.to_s
    @missing = Net::HTTP.get_response(URI.parse(URI.escape(@url))).body
    
end

puts missing_category(2)
