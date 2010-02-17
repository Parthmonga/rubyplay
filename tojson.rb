#!/usr/bin/env ruby


require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'optparse'
require 'json'


class Chamber
  attr_accessor :name, :address, :state, :city, :zip
  def to_json(*a)
     {
       'json_class'   => self.class.name, # = 'Chamber'
       'data'         => [ name, address, state, city, zip ]
     }.to_json(*a)
  end

end


oaktown = Chamber.new

oaktown.name = 'Oakland Chamber of Commerce'
oaktown.address = '475 14th street'
oaktown.state = 'CA'
oaktown.city = 'Oakland'
oaktown.zip = '94612'

ot_json = oaktown.to_json
puts ot_json
