require 'rubygems'
require 'net/http'
require 'uri'
require 'cgi'
require 'optparse'
require 'json'
require 'yaml'


@@yaml_file = 'gcm.yml'
yamlstring = ''
File.open(@@yaml_file, "r") { |f| yamlstring = f.read }
config = YAML::load(yamlstring)


key = config['key']
registration_id = config['registration_id']

timeToLive = 30
delayWhileIdle = "true" #true or false

url = URI.parse('https://android.googleapis.com/gcm/send')
req = Net::HTTP::Post.new(url.path)
req.content_type = 'application/json'
req.set_form_data({'registration_id'=>registration_id, 'timeToLive'=>timeToLive, 'delay_while_idle'=>delayWhileIdle, 'data.url'=>"/b2test", 'data.alert'=>"Hello, #{rand(6)+1}! Just another test. #{Time.now}"})

req.add_field "Authorization", "key=" + key                                     

res = Net::HTTP.new(url.host, url.port)                                         
res.use_ssl = true                                                              
res.set_debug_output $stderr                                                    
res.start {|http| http.request(req) }
