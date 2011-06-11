class Source < ActiveRecord::Base
  has_many :tv_shows, :dependent => :destroy
  
  def scrape
    scraper_class.extract_shows(url).each do |show_data|
      Source.find_or_create(tv_shows, :name, show_data)
    end
    save!
    cleanup(tv_shows)
    self.reload

    tv_shows.each do |show|
      scraper_class.extract_episodes(show).each do |ep_data|
        Source.find_or_create(show.episodes, :name, ep_data)
      end
      show.save!
      cleanup(show.episodes)
    end
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

  def cleanup(collection)
    collection.where(
      collection.arel_table[:updated_at].lt(DateTime.now - 2.hours)
    ).destroy_all
  end
end
