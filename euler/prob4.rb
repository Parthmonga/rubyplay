#!/usr/bin/env ruby

# A palindromic number reads the same both ways. The largest palindrome made 
# from the product of two 2-digit numbers is 9009 = 91 × 99.

# Find the largest palindrome made from the product of two 3-digit numbers.

product = 0
palindromes = Array.new
for i in 100..999 do
  for j in 100..999 do
    product = i * j
    if product.to_s.reverse == product.to_s
      puts "#{product} is a palindrome" 
      palindromes << product
    end
  end
end

puts palindromes.sort.last
puts palindromes.sort.first
