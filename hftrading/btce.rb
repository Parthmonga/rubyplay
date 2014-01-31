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

def buy(price)
  begin
    ticker = Btce::Ticker.new "ltc_usd"

    api_hash = { }
    puts "buy #{Time.now}: #{price}: #{ticker.buy.to_f}: #{ticker.sell.to_f}"
    if ticker.buy.to_f <= price
      api_hash = {
        "pair" => "ltc_usd",
        "type" => "buy",
        "rate" => ticker.buy.to_f,
        "amount" => 2.1,
      }
      trade = Btce::TradeAPI.new_from_keyfile.trade_api_call "Trade", api_hash
      puts trade.inspect
      return 1
    end
  rescue => e
    puts e.message
  end
  return 0
end

def sell(price)
  begin
    ticker = Btce::Ticker.new "ltc_usd"

    api_hash = { }
    puts "sell: #{Time.now}: #{price}: #{ticker.buy.to_f} #{ticker.sell.to_f}"
    if ticker.sell.to_f >= price
      api_hash = {
        "pair" => "ltc_usd",
        "type" => "sell",
        "rate" => ticker.sell.to_f,
        "amount" => 2.0958,
      }
      trade = Btce::TradeAPI.new_from_keyfile.trade_api_call "Trade", api_hash
      puts trade.inspect
      exit
    end
  rescue => e
    puts e.message
  end
  return 1
end

iter = 0
buy_price   = ARGV[0].to_f
sell_price  = ARGV[1].to_f

puts "buy  price: #{buy_price}"
puts "sell price: #{sell_price}"

isBuy  = 1
# isSell = 1
isSell = 0

while iter <= 0
  if isBuy == 1
    isSell = buy(buy_price)
    if isSell == 1
      isBuy = 0
    end
  end

  if isSell == 1
    isSell = sell(sell_price)
  end
  sleep 1
end
