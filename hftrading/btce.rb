#!/usr/bin/env ruby

require 'rubygems'
require 'btce'


ticker = Btce::Ticker.new "ltc_usd"
puts ticker.last

info = Btce::TradeAPI.new_from_keyfile.get_info
puts info

@trade_hash_example = {
      "date" => Time.now.to_i,
      "price" => 4.85,
      "amount" => 0.5,
      "tid" => Time.now.to_i,
      "price_currency" => "USD",
      "item" => "NMC",
      "trade_type" => "bid"
}

@trade = Btce::Trade.new_from_json @trade_hash_example

puts @trade.inspect

puts
puts "trying trade..."
# results = Btce::TradeAPI.new_from_keyfile.trade_api_call "Trade", @trade_hash_example
# puts results.inspect
# @api_hash = {
#   "pair" => "nmc_usd",
#   "type" => "buy",
#   "rate" => 4.85,
#   "amount" => 0.5,
# }
# trade = Btce::TradeAPI.new_from_keyfile.trade_api_call "Trade", @api_hash
# puts trade.inspect

iter = 0
while iter <= 0
  ticker = Btce::Ticker.new "ltc_usd"
  puts ticker.last.to_f
  if ticker.last.to_f >= 21.6
    @api_hash = {
      "pair" => "ltc_usd",
      "type" => "sell",
      "rate" => ticker.last.to_f,
      "amount" => 2.0958,
    }
    trade = Btce::TradeAPI.new_from_keyfile.trade_api_call "Trade", @api_hash
    puts trade.inspect
  end

  sleep 1
end
