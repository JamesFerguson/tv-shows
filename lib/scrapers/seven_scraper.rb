require Rails.root + 'lib/scrapers/base_scraper'

class SevenScraper < BaseScraper
  def self.extract_shows(source_url)
    shows_url = URI.parse(source_url)
    
    page = Nokogiri::HTML(read_url(source_url))
    
    shows = page.css("#atoz h3 a").map do |node|
      {:name => node.text, :url => shows_url.merge(node.attributes['href'].value).to_s}
    end
  end

  def self.extract_episodes(show)
    show_url = URI.parse(show.url)
    page = Nokogiri::HTML(read_url(show.url))
    
    episodes = page.css("ul#related-episodes .itemdetails h3 a").map do |node|
      {
        :name => node.children[3].text,
        :url => show_url.merge(node.attributes['href'].value).to_s
      }
    end
  end
end