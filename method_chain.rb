class Something
  module Base  
    def my_method
      # (A) original functionality
      puts "A"
    end
  end

  module PreExtension
    def my_method
      # (B) before the original
      puts "B"
      super # calls whatever was my_method before this definition was made
    end
  end

  module PostExtension
    def my_method
      super # calls whatever was my_method before this definition was made
      # (C) after the original
      puts "C"
    end
  end

  include Base # this is needed to place the base methods in the inheritance stack
  include PreExtension # this will override the original my_method
  include PostExtension # this will override my_method defined in PreExtension
end

s = Something.new
s.my_method 
#=> this is a twice extended method call that will execute code in this order:
#=> (B) before the original
#=> (A) the original
#=> (C) after the original
