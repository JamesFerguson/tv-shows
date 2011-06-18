class Source < ActiveRecord::Base
  has_many :tv_shows, :dependent => :destroy
  has_many :episodes, :through => :tv_shows
  
  has_friendly_id :name, :use_slug => true
  
  def scrape
    mark_all(tv_shows)
    scrape_shows
    cleanup(tv_shows, DateTime.now - 4.months)
    self.reload

    mark_all(episodes)
    scrape_episodes
    cleanup(episodes, DateTime.now - 2.weeks)
  end

  def scraper_class
    require "scrapers/#{scraper.underscore}"
    @scraper ||= scraper.constantize
  end
  
  def self.find_or_create(collection, find_key, create_or_update_data)
    item = collection.where(find_key => create_or_update_data[find_key]).first
    item.try(:update_attributes!, create_or_update_data)
    item ||= collection.create!(create_or_update_data)
  end


  private

  def scrape_shows
    scraper_class.extract_shows(self.url).each do |show_data|
      Source.find_or_create(tv_shows, :name, show_data.merge(:deactivated_at => nil))
    end
    
    save!
  end
  
  def scrape_episodes
    tv_shows.active.each do |show|
      scrape_show_episodes(show)
    end
  end
  
  def scrape_show_episodes(show)
    scraper_class.extract_episodes(show).each do |ep_data|
      Source.find_or_create(show.episodes, :name, ep_data)
    end

    show.save!
  end
  
  def mark_all(collection)
    collection.where(:deactivated_at => nil).each do |item|
      item.update_attribute(:deactivated_at, DateTime.now)
    end
  end

  def cleanup(collection, threshold)
    collection.where(
      collection.arel_table[:deactivated_at].lt(threshold)
    ).destroy_all
  end
end
