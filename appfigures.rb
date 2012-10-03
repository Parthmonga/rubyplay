require 'rubygems'
require 'net/http'
require 'httpclient'
require 'uri'
require 'cgi'
require 'optparse'
require 'json'
require 'yaml'

@@APPS_FIGURE_API = "https://api.appfigures.com/v1.1"
@@yaml_file = 'af.yml'
yamlstring = String.new
File.open(@@yaml_file, "r") { |f| yamlstring = f.read }
config = YAML::load(yamlstring)
puts config['AF_USERNAME']
puts config['AF_PASSWORD']
path = "/users/#{config['AF_USERNAME']}/products"
puts path
client = HTTPClient.new
client.set_auth("https://api.appfigures.com", config["AF_USERNAME"], config["AF_PASSWORD"])
res = client.get "#{@@APPS_FIGURE_API}#{path}"
af_json = JSON.parse(res.body)
   
af_json.each { |key, val|
  puts "key: #{key}"
  puts "val: #{val}"
}

