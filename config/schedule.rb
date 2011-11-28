# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
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

env 'MAILTO', "jim"

set :output, "~/Coding/tv-shows/log/cron_log.log"

every :day, :at => ['9am', '12pm', '3:30pm', '8pm'] do
  command "cd ~/Coding/tv-shows && heroku rake cron --trace"
end

every :day, :at => ['10am', '2:30pm'] do
  command "cd ~/Coding/tv-shows && RAILS_ENV=development bundle exec rake cron --trace"
end

