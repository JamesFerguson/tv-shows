desc "Runs cron maintenance tasks."
task :cron => 'web:scrape' do
  puts "Running cron at #{Time.now.strftime('%Y/%m/%d %H:%M:%S')}..."
end