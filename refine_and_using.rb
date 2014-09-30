#!/usr/bin/env ruby
#
#

module OuterSpace

  module StringExtensions 
    refine String do
      def to_alphanumeric 
        gsub(/[^\w\s]/, '')
      end 
    end
  end
  
  using StringExtensions
  
  puts "my *1st* refinement!".to_alphanumeric

end

module StringExtensions
  refine String do
    def reverse
      "esrever"
    end
  end
end

module StringStuff
  using StringExtensions
  puts "my_string".reverse    # => "esrever"
end

puts "my_string".reverse      # => "gnirts_ym"
