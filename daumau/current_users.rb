#!/usr/bin/env ruby
require 'pg'
require 'date'


minutes = ARGV[0] || 5

minutes = minutes.to_i

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


a_times = Array.new
(1..minutes).each do |i|
  t = Time.now - (i*60) + (8*3600)
  a = t.to_s.split(/\s+/)
  a_times <<  a[0] + 'T' + a[1].gsub(/:[0-9]+$/,'')
end

fh.each { |line|

  a_times.each do |s_time|
    if line.include? s_time
      # grep this [-uid:704974-]
      if line =~ /uid:([0-9]+)\-\]/
        @users << $1 
      end
    end
  end

}
fh.close

@user_counts = Hash.new



@users.each { |user|
  begin
    @user_counts[user] = @user_counts[user] + 1
  rescue
    @user_counts[user] = 1
  end
}

@user_counts.each { |user, count|
  # puts "#{count} : #{user} : #{get_slug(user)}"
  puts "#{count} : #{user}" 
}

