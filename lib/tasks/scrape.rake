namespace :web do
  
  desc "Scrape all shows and episodes from all sources."
  task :scrape => :environment do
    puts "Scraping teh interwebs."
    
    Rake::Task[:scrape_shows]
#    Rake::Task[:scrape_episodes]

    puts "Interwebs scraped."
  end

  desc "Scrape show from all sources"
  task :scrape_shows => :environment do
    puts caller.join("\n")

    puts "Scraping teh shows."

    Source.all.each(&:scrape_shows)

    puts "Shows scraped."
  end

end
