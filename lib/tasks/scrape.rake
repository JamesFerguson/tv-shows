namespace :web do
  
  desc "Scrape all shows and episodes from all sources."
  task :scrape => :environment do
    puts "Scraping teh interwebs."
    
    Source.all.map(&:scrape)
    
    puts "Interwebs scraped."
  end

end
