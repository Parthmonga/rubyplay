# checkout http://projecteuler.net for details

# project euler problem #1
def three_or_five(num)

  total = 0
  below_num = num - 1
  (0..below_num).each do |i|
    if (i % 3 == 0) or (i % 5 == 0)
      t = i
      puts t
      total = total + t
    end
  end

  total
end

# problem #2
def fib_lite(n)
  return n if n < 2 
  vals = [0, 1] 
  n.times do
    vals.push(vals[-1] + vals[-2]) 
  end
  return vals.last 
end

@first  = 0
@second = 1  
@sum    = 0
@even_sum = 0


def fib(ordinal)
  if ordinal == 0
    return @sum
  else
    unless ordinal == -1
      @sum = @first + @second
      @second = @first
      @first = @sum
      if @sum % 2 == 0 
        puts @sum
        @even_sum = @even_sum + @sum
        puts "even_sum: #{@even_sum}"
      end
      fib(ordinal - 1)
    end
  end
  @sum
end

def primes(ordinal)

  is_prime = 1
  (2..(ordinal/2)).each do |i|
    if ordinal % i == 0
      is_prime = 0
    end
  end

  puts "#{ordinal} is prime" if is_prime == 1

  is_prime
end

def factors(ordinal)



end

# total = three_or_five(1000)
# puts total

# puts "fib_lite"
# puts fib(50)


