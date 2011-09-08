require Rails.root + 'lib/scrapers/ten_scraper'

class TenMicroSiteScraper < TenScraper
  
  protected

  # These only have one playlist in the feed, no childPlaylists nothing.
  def self.filter_playlists(playlist)
    [playlist]
  end
end
