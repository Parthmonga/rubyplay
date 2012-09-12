require 'mail'


def parse_file(filename)

  lines = File.open(filename, 'r')
  text  = ''

  lines.each { |line| 
    text = text + line
  }

  text
end

Mail.defaults do
  delivery_method :smtp, { :address   => "smtp.sendgrid.net",
                           :port      => 587,
                           :domain    => "",
                           :user_name => "",
                           :password  => "",
                           :authentication => 'plain',
                           :enable_starttls_auto => true }
end

begin
mail = Mail.deliver do
  to 'foobar@example.com'
  from 'Baz <bazquux@example.com>'
  subject 'This is the subject of your email'
  text_part do
    body 'Hello world in text'
  end
  html_part do
    content_type 'text/html; charset=UTF-8'
    body parse_file('/Users/newuser/Downloads/template.html')
  end
end

rescue Error
  puts Error
  puts 'we need to redo'


end
