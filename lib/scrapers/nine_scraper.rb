require Rails.root + 'lib/scrapers/base_scraper'

class NineScraper < BaseScraper
  def self.extract_shows(source_url)
    shows_url = URI.parse(source_url)
    
    page = Nokogiri::HTML(read_url(source_url))

    shows = page.css("#main a.linkItem").map do |node|
      {:name => node.text, :url => shows_url.merge(node.attributes['href'].value).to_s}
    end
  end
  
  def self.extract_episodes(show)
    show_url = URI.parse(show.url)
    page = Nokogiri::HTML(read_url(show.url))
    
    episodes = page.css("#all_articles_index .tr").map.with_index do |node, index|
      {
        :name => "Episode #{node.children[1].text}: #{node.css('.season_title').text}",
        :url => show_url.
                  merge(
                    node.css('.watch_now_normal').first.attributes['href'].value
                  ).to_s,
        :ordering => index + 1
      }
    end
  end
end
