begin
  fail "Oops"; 
rescue => error
  raise if error.message != "Oops" 
end
