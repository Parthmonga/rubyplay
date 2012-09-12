#!/usr/bin/env ruby

module BarModule
  def hello_world
    puts "Hello World"
  end
end

class BaseClass
  def class_method
    puts "In class method"
  end
end

class Foo < BaseClass
  include BarModule
end

f = Foo.new
f.class_method
f.hello_world

String.send(:include, BarModule)
s = "Arbitrary String"
s.hello_world
