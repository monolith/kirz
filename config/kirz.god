RAILS_ROOT = File.dirname(File.dirname(__FILE__))

if RAILS_ROOT.include? "current"
  RAILS_ENV="production"
else
  RAILS_ENV="development" # assumption
end

def generic_monitoring(w, options = {})
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 10.seconds
      c.running = false
    end
  end

  w.restart_if do |restart|
    restart.condition(:memory_usage) do |c|
      c.above = options[:memory_limit]
      c.times = [3, 5] # 3 out of 5 intervals
    end

    restart.condition(:cpu_usage) do |c|
      c.above = options[:cpu_limit]
      c.times = 5
    end
  end

  w.lifecycle do |on|
    on.condition(:flapping) do |c|
      c.to_state = [:start, :restart]
      c.times = 5
      c.within = 5.minute
      c.transition = :unmonitored
      c.retry_in = 10.minutes
      c.retry_times = 5
      c.retry_within = 2.hours
    end
  end
end


# THINKING SPHINX

God.watch do |w|
  script = "cd #{RAILS_ROOT} && RAILS_ENV=#{RAILS_ENV} rake"
  w.name = "kirz-thinking-sphinx"
  w.group = "kirz"
  w.interval = 60.seconds
  w.start = "#{script} ts:start"
  w.restart = "#{script} ts:restart"
  w.stop = "#{script} ts:stop"
  w.start_grace = 20.seconds
  w.restart_grace = 20.seconds
  w.pid_file = "#{RAILS_ROOT}/log/searchd.#{RAILS_ENV.downcase}.pid"

  w.behavior(:clean_pid_file)

  generic_monitoring(w, :cpu_limit => 80.percent, :memory_limit => 100.megabytes)
end

