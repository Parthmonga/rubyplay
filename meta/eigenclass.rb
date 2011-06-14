#!/usr/bin/env ruby



module Greetings
  def self.spanish; 'hola'; end
end

class Intro
  include Greetings
end

# the code below doesn't work but an Eigenized version of it will
# Intro.spanish

module Salutations
  def spanish; 'hola'; end
end

class Eigenintro
  class << self
    include Salutations 
  end
end

puts Eigenintro.spanish

