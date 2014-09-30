#!/usr/bin/env ruby
#


class C
  def public_method
    self.private_method
  end

  private

  def private_method; end
end

C.new.public_method


class D
  def public_method
    private_method
  end

  private

  def private_method; end
end

D.new.public_method


