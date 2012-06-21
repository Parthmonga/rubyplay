#!/usr/bin/env ruby


require 'rubygems'
require 'rexml/document'

str = '<?xml version="1.0" encoding="UTF-8"?>
<hash>
  <error>
    <message>unauthorized</message>
    <status type="integer">401</status>
  </error>
</hash>
'
puts str

$parsed_body = REXML::Document.new(str)

puts $parsed_body.root.elements['error'].elements['status'].text
