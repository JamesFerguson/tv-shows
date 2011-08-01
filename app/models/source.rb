class Source < ActiveRecord::Base
  has_many :tv_shows, :dependent => :destroy
  has_many :episodes, :through => :tv_shows
  
  has_friendly_id :name, :use_slug => true
  
  def scrape
    scrape_shows
    scrape_episodes
  end

  def scrape_shows
    mark_all(tv_shows)
    scrape_show_data
    cleanup(tv_shows, DateTime.now - 4.months)
    self.reload
  end

  def scrape_episodes
    mark_all(episodes)
    episodes.each { |e| e.update_attributes!(:ordering => nil) }
    
    scrape_episode_data
    
    cleanup(episodes, DateTime.now - 2.weeks)
  end

  def scraper_class
    require "scrapers/#{scraper.underscore}"
    @scraper ||= scraper.constantize
  end
  
  def self.find_or_create(collection, find_key, create_or_update_data)
    item = collection.where(find_key => create_or_update_data[find_key]).first
    if item
      create_or_update_data.merge!(:deactivated_at => nil) if item.attributes.keys.include?('deactivated_at')
      item.update_attributes!( create_or_update_data)
    end
    item ||= collection.create!(create_or_update_data)
  end


  private

  def scrape_show_data
    scraper_class.extract_show_urls(self.url).each do |url|
      scraper_class.extract_shows(url).each do |show_data|
        Source.find_or_create(tv_shows, :name, show_data)
      end
    end

    save!
  end
  
  def scrape_episode_data
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
