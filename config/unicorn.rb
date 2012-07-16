# config/unicorn.rb

worker_processes 2
timeout 30
preload_app true


listen "/home/twitterexchange/twitterexchange/shared/unicorn.sock", :backlog => 64

pid "/home/twitterexchange/twitterexchange/shared/pids/unicorn.pid"

# Set the path of the log files inside the log folder of the testapp
stderr_path "/home/twitterexchange/twitterexchange/shared/log/unicorn.stderr.log"
stdout_path "/home/twitterexchange/twitterexchange/shared/log/unicorn.stdout.log"

before_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end


  sleep 1
end

after_fork do |server, worker|
  # Replace with MongoDB or whatever
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end


end