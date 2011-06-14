class Source < ActiveRecord::Base
  has_many :tv_shows, :dependent => :destroy
  
  def scrape
    mark_all(tv_shows)
    scrape_shows
    cleanup(tv_shows)
    self.reload

    scrape_episodes
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
