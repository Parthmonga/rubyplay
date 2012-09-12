require 'rubygems'
require 'twilio-ruby'



message = 'sup there'
@tw_account_sid = ''
@tw_auth_token  = ''

@client = Twilio::REST::Client.new(@tw_account_sid, @tw_auth_token)


@account = @client.account
@message = @account.sms.messages.create({:from => '+15555555555', :to => '555-555-5454', :body => message})

