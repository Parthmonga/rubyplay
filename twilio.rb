require 'rubygems'
require 'twilio-ruby'
require 'yaml'


yamlstring = ''
File.open("./twilio.yaml", "r") { |f|
  yamlstring = f.read
}

@settings = YAML::load(yamlstring)





message = 'sup there'
@tw_account_sid = @settings['tw_account_sid']
@tw_auth_token  = @settings['tw_auth_token']

@client = Twilio::REST::Client.new(@tw_account_sid, @tw_auth_token)


@account = @client.account
@message = @account.sms.messages.create({:from => '+15555555555', :to => '555-555-5454', :body => message})

