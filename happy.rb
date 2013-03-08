
require 'tweetstream'
require 'yaml'


yamlstring = ''
File.open("./auth.yaml", "r") { |f|
  yamlstring = f.read
}

settings = YAML::load(yamlstring)
puts settings.inspect



TweetStream.configure do |config|
  config.consumer_key       = settings['consumer_key']
  config.consumer_secret    = settings['consumer_secret']
  config.oauth_token        = settings['access_token']
  config.oauth_token_secret = settings['access_secret']
  config.auth_method        = :oauth
end


TweetStream::Client.new.track('happy birthday') do |status|
  puts "#{status.text}"
  puts "--"
end

