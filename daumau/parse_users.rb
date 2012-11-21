#!/usr/bin/env ruby
require 'pg'
require 'date'


def get_slug(id)
  conn = PGconn.new(ENV['PROD_HOST'], ENV['PROD_PORT'], '', '', ENV['PROD_DB'],ENV['PROD_USER'],ENV['PROD_PASS'])
  sql = "select slug from users where id = #{id}"
  res = conn.exec(sql)
  @slug = nil
  res.each { |result|
    @slug = result['slug']
  }
  conn.close()
  return @slug
end
fh = File.open("#{ENV['HOME']}/log/user.log", 'r')

@users = Array.new

puts 'parsing user_id'
fh.each { |line|

  if line =~ /:([0-9]+)\]/
    @users << $1 
  end

}

@user_counts = Hash.new


puts 'do user_counts'
puts "@users.count: #{@users.count}"

@users.each { |user|
  begin
    @user_counts[user] = @user_counts[user] + 1
  rescue
    @user_counts[user] = 1
  end
}

@user_counts.each { |user, count|
  puts "#{count} : #{user} : #{get_slug(user)}"
}

fh.close
