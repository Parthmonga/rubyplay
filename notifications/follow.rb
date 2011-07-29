#!/usr/bin/env ruby

require 'observer'

class FollowNotifier
	include Observable

	def initialize(user)
		@user = user
	end

	def run
		lastStatus = nil
		loop do
			status = Status.fetch(@user)
			print "Current follow status: #{status}\n"
			if status != lastStatus
				changed        # notify observers
				lastStatus = status
				notify_observers(Time.now, status)
			end # end if
			sleep 1
		end # end loop
	end # end run
end # end class

class Status      ### A mock class to fetch a status: follow or unfollow.
	def Status.fetch(user)
	  bit = rand(2)
		status = ''
		if bit == 0
			status = 'follow'
		else
			status = 'unfollow'
		end
		status
	end
end

class Alerter      ### An abstract observer of FollowNotifier objects.
	def initialize(follownotifier)
		follownotifier.add_observer(self)
	end
end

class AlertUnfollow < Alerter
	def update(time, status)
		if status == 'unfollow'
			print "--- #{time.to_s}: unfollow\n"
		end
	end
end

class AlertFollow   < Alerter
	def update(time, status)
		if status == 'follow'
			print "--- #{time.to_s}: follow\n"
		end
	end
end

status = FollowNotifier.new("barce")
# AlertUnfollow.new(status)  ### we do not need to alert on unfollow.
AlertFollow.new(status)
status.run


