
class External

  def self.results
    self.counts
  end

  def self.counts
    as_of_time = Time.now if as_of_time.nil?
    # as_of_time = Time.new(as_of_time.year,as_of_time.month,as_of_time.day,as_of_time.hour,0,0,"+00:00")
    
    
    pg = %x[echo "select count(*) from external_api_events where load_one > 90 and created_at <= '#{as_of_time}'" | heroku pg:psql -a viame-logging]
    
    @count = 0
    @i = 0
    a_pg = pg.split(/\n/)
    a_pg.each { |pg| 
      if @i == 3
        if pg =~ /([0-9]+)/ 
          @count = $1
        end
      end
      @i = @i + 1
    }
    @count
  end
end

puts  External.results
