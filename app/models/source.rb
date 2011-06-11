class Source < ActiveRecord::Base
  has_many :tv_shows
  
  def scrape
    my_scraper.extract_shows(url).each do |show_data|
      self.find_or_create(tv_shows, :name, show_data)
    end
    save!
    cleanup(tv_shows)
    
    tv_shows.each do |show|
      my_scraper.extract_episodes(show).each do |ep_data|
        self.find_or_create(show.episodes, :name, ep_data)
      end
      show.save!
      cleanup(show.episodes)
    end
  end

  # private

  def self.find_or_create(collection, find_key, create_or_update_data)
    item = collection.where(find_key => create_or_update_data[find_key]).first
    item.try(:update_attributes!, create_or_update_data)
    item ||= collection.create!(create_or_update_data)
  end

  def my_scraper
    require "scrapers/#{scraper.underscore}"
    @scraper ||= scraper.constantize
  end
  
  def cleanup(collection)
    debugger
    collection.where(
      collection.arel_table[:updated_at].lt(DateTime.now - 2.hours)
    ).destroy_all
  end
end
