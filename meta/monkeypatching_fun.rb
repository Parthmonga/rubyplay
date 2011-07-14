#!/usr/bin/env ruby

class String

  def reverse
    reversed = ''
    self.length.downto 0 do |i|
      unless self[i].nil?
        reversed.concat(self[i])
      end
    end
    reversed
  end

end

s = String.new('test')

puts s
puts s.reverse

@first  = 0
@second = 1  
@sum    = 0


def fib(ordinal)
  unless ordinal == 0
    @sum = @first + @second
    @second = @first
    @first = @sum
    fib(ordinal - 1)
  end
  @sum
end

puts fib(8)

def power(base, exponent)
  @result = 1
  (1..exponent).each { |i|
    @result = @result * base
  }  
  @result
end


puts power(2, 3)

# qpower determines base^exponent in log n time
def qpower(base, exponent)

  if exponent == 0
    return 1
  end

  temp = qpower(base, exponent / 2)

  if (exponent % 2 == 0)
    return temp * temp
  else
    return base * temp * temp
  end
end

puts qpower(2, 3)


class NilClass

  def teetimes_for(date)
    puts 'hi'
  end

end

a = nil
date = ''
a.teetimes_for(date)
