#!/usr/bin/env ruby



class C
  def to_escape
    puts 'run'
  end
end


obj = C.new
puts obj.inspect
# puts obj.class.instance_methods
# puts obj.class.instance_variables
obj.to_escape

class C

  def to_stay
    puts 'stay'
  end


end

# puts obj.class.instance_methods

obj.to_stay
