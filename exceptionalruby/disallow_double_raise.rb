# disallowing a double raise helps with debugging
module NoDoubleRaise 
  def error_handled!
    $! = nil 
  end
  def raise(*args)
    if $! && args.first != $!
      warn "Double raise at #{caller.first}, aborting"
      exit! false 
    else
      super 
    end
  end 
end

class Object
  include NoDoubleRaise
end

begin
  raise "Initial failure"
rescue
  raise "Secondary failure"
end

