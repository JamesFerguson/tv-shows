desc "Runs cron maintenance tasks."
task :cron => :scrape do
  puts "Running cron at #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}..."
end