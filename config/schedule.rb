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

  path = "/var/www/apps/kirz/current"

  every :reboot do
    # start up god monitoring
#    command "god start kirz -c #{Whenever.path}/config/kirz.god"
    command "cd #{path} && RAILS_ENV=production rake ts:start"
  end

  every :sunday, :at => "5:00am" do
    command "rm -rf #{path}/tmp/cache"
    command "cd #{path} && rake ts:index RAILS_ENV=production"
  end

