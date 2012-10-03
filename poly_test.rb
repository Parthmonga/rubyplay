class Dog

  def walk
    puts "going 2 feet"
  end

  def walk(feet = 0)
    puts "going #{feet} feet"
  end

end

d = Dog.new
d.walk
d.walk(3)
