#!/usr/bin/env ruby

require 'rubygems'
require 'mechanize'


a = Mechanize.new
a.get('http://localhost.com:3000/') do |page|
  # Click the login link
  login_page = a.click(page.link_with(:text => /Sign In/))

  # Submit the login form
  my_page = login_page.form_with(:action => '/users/sign_in') do |f|
    # TODO: add email & pass
    f.send("user[email]=", "")
    f.send("user[password]=", "")
  end.click_button

  tsv_page = a.get("http://localhost.com:3000/tsv/aggregates.json?events=applications%2Fmanifests%23show&metrics=alltime_hits&application=3f8a5d20-9f4a-0130-a94a-22000afc0b0e") 
  puts tsv_page.response.inspect
end

