#!/usr/bin/env ruby

# https://reprog.wordpress.com/2010/04/19/are-you-one-of-the-10-percent/
# woohoo I am one of the 10 percent!

class Leaf
  attr_accessor :left, :right, :value
  
  def initialize(value)
    self.value = value
    @@size     = 0
  end

  def add(leaf)
    self.traverse(leaf,self)
    @@size = @@size + 1
  end

  def traverse(leaf,current)
    puts "doing traverse"
    if leaf.value < current.value && !current.left.nil?
      puts 'continue left'
      traverse(leaf,current.left)  
    end
    if leaf.value >= current.value && !current.right.nil?
      puts 'continue right'
      traverse(leaf,current.right) 
    end

    if leaf.value < current.value && current.left.nil?
      puts 'assign left'
      current.left  = leaf 
    end
    if leaf.value >= current.value && current.right.nil?
      puts 'assign right'
      current.right = leaf 
    end
  end

  def find(val,leaf)
    return leaf.right if val == leaf.right.value
    return leaf.left  if val == leaf.left.value
    find(val,leaf.left) if val < leaf.value
    find(val,leaf.right) if val > leaf.value
  end

  def size
    @@size
  end
end


#        55
#       / \
#      33 68
#     /  /  \
#   21 64    70

leaf = Leaf.new(55)
leaf.add(Leaf.new(33))
leaf.add(Leaf.new(68))
leaf.add(Leaf.new(21))
leaf.add(Leaf.new(64))
leaf.add(Leaf.new(70))

# test if this is true
puts "got this wrong" if leaf.left.value != 33
puts "got this wrong" if leaf.right.value != 68

puts "got this wrong" if leaf.left.left.value !=21
puts "got this wrong" if leaf.right.left.value !=64
puts "got this wrong" if leaf.right.right.value !=70

puts leaf.find(68,leaf).inspect
