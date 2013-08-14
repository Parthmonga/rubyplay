require 'rubygems'
require 'twilio-ruby'
require 'yaml'
require 'optparse'

def output_help
  puts "usage: dragonsbreathe.rb -i imgfile -k memcache_key -n times"
end

opts = OptionParser.new
OptionParser.new do |o|
  o.on('-p PHONE') { |phone| $phone = phone}
  o.on('-m MESSAGE') { |message| $message= message}
  o.on('-h') { output_help; exit }
  o.parse!
end

@phone   = phone
@message = message

yamlstring = ''
File.open("./twilio.yaml", "r") { |f|
  yamlstring = f.read
}

@settings = YAML::load(yamlstring)



# puts @settings['tw_account_sid']
# puts @settings['tw_auth_token']


@tw_account_sid = @settings['tw_account_sid']
@tw_auth_token  = @settings['tw_auth_token']
@tw_phone       = @settings['tw_phone']

@client = Twilio::REST::Client.new(@tw_account_sid, @tw_auth_token)


@account = @client.account
@message = @account.sms.messages.create({:from => @tw_phone, :to => @phone, :body => @message})

puts @message
puts @message.inspect
