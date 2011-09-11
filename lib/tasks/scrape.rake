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

    Source.all.each do |source|
      puts "Scraping shows from #{source.name}"
      source.scrape_shows
    end

    puts "Shows scraped."
  end

  desc "Scrape episodes for all shows"
  task :scrape_episodes => :environment do
    puts "Scraping teh episodes."

    Source.all.each do |source|
      puts "Scraping episodes from #{source.name}"
      source.scrape_episodes
    end

    puts "Episodes scraped."
  end

end
