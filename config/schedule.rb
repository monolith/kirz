# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

case RAILS_ENV
  when "production"
    RAILS_ROOT = "/var/www/apps/kirz/current"
  when "development"
    RAILS_ROOT = "~/rails_apps/kirz"
  else
    environment_should_be_skipped = true
end

unless environment_should_be_skipped # set above in the case statement

  every :reboot do
    # start up god monitoring
    command "god start kirz -c #{RAILS_ROOT}/config/kirz.god"
  end

  every :sunday, :at => "5:00am" do
    command "rm -rf #{RAILS_ROOT}/tmp/cache"
    command "cd #{RAILS_ROOT} && rake ts:index RAILS_ENV=#{RAILS_ENV}"
  end

end

