#!/usr/bin/env ruby

require 'rubygems'
require 'btce'


ticker = Btce::Ticker.new "ltc_usd"
puts ticker.last

info = Btce::TradeAPI.new_from_keyfile.get_info
puts info
