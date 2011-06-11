class NineScraper
  def self.extract_shows(source_url)
    shows_url = URI.parse(source_url)
    
    page = Nokogiri::HTML(shows_url.open)
    
    shows = page.css("#main a.linkItem").map do |node|
      {:name => node.text, :url => shows_url.merge(node.attributes['href'].value).to_s}
    end
  end
  
  def self.extract_episodes(show)
    page = Nokogiri::HTML(open(show.url))
    
    shows = page.css("#all_articles_index .tr").map do |node|
      {
        :name => "Episode #{node.children[1].text}: #{node.css('.season_title').text}",
        :url => URI.parse(show.url).
                  merge(
                    node.css('.watch_now_normal').first.attributes['href'].value
                  ).to_s
      }
    end
  end
end