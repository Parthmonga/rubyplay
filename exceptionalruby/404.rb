require 'net/http'
class Net::HTTPInternalServerError
  def exception(message="Internal server error, dude.") 
    RuntimeError.new(message)
  end 
end

class Net::HTTPNotFound
  def exception(message="404 Not Found, baby!")
    RuntimeError.new(message) 
  end
end

response = Net::HTTP.get_response(URI.parse("http://avdi.org/notexist"))
if response.code.to_i >= 400 
  raise response
end
