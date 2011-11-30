#!/usr/bin/env ruby

# h = MethodHash.new
# h.#{foo} = 'bar'
# h.foo
#    => 'bar'

class MethodHash

  def initialize
    @myhash = {}
  end

  def mh_assign(m_name)
    m_name = m_name.to_sym
    unless self.respond_to?(m_name)
      meta = class << self; self; end
      meta.send(:define_method, m_name) { @myhash[m_name] }
      meta.send(:define_method, :"#{m_name}=") { |x| @myhash[m_name] = x }
    end
  end

  def method_missing(mid, *args)
    method_name = mid.id2name
    len = args.length
    if method_name =~ /=$/
      method_name.chop!
      self.mh_assign(method_name)
      @myhash[method_name.intern] = args[0]
    elsif len == 0
      @myhash[mid]
    else 
      raise NoMethodError, "undefined method `#{method_name}' for #{self}", caller(1)
    end
  end
end


h = MethodHash.new

puts 'assigning bar'
h.foo = 'bar'
puts "printing h.foo"
puts h.foo
puts "printing h.foo = 'bar2'"
h.foo = 'bar2'
puts h.foo
puts h.inspect
