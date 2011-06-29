namespace :web do
  
  desc "Scrape all shows and episodes from all sources."
  task :scrape => :environment do
    puts "Scraping teh interwebs."
    
    Rake::Task['web:scrape_shows'].invoke
    Rake::Task['web:scrape_episodes'].invoke

    puts "Interwebs scraped."
  end

  desc "Scrape show from all sources"
  task :scrape_shows => :environment do
    puts "Scraping teh shows."

    Source.all.each(&:scrape_shows)

    puts "Shows scraped."
  end

  desc "Scrape episodes for all shows"
  task :scrape_episodes => :environment do
    puts "Scraping teh episodes."

    Source.all.each(&:scrape_episodes)

    puts "Episodes scraped."
  end

end
