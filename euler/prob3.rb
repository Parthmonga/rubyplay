#!/usr/bin/env ruby


# The prime factors of 13195 are 5, 7, 13 and 29.
# What is the largest prime factor of the number 600851475143 ?

# get factors

def primes(ordinal)


  is_prime = 1
  limit = ordinal.to_i / 2

  (2..limit).each do |i|
    if ordinal % i == 0
      is_prime = 0
    end
  end

  if is_prime == 1
    return ordinal
  end

  return 0
end

def factors(n)
  i_sentinel = 1
  i_limit = n / 2
  i_mod = 0
  i = 1
  while i <= i_limit
    i_mod = n % i
    puts i if i_mod == 0 and primes(i) > 0
    i += 1
  end

end



# start = 13195
start = 600851475143
factors(start)

