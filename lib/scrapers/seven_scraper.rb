class SevenScraper
  def self.extract_shows(source_url)
    shows_url = URI.parse(source_url)
    
    page = Nokogiri::HTML(shows_url.open)
    
    shows = page.css("#atoz h3 a").map do |node|
      {:name => node.text, :url => shows_url.merge(node.attributes['href'].value).to_s}
    end
  end

  def self.extract_episodes(show)
    show_url = URI.parse(show.url)
    page = Nokogiri::HTML(show_url.open)
    
    episodes = page.css("ul#related-episodes .itemdetails h3 a").map do |node|
      {
        :name => node.children[3].text,
        :url => show_url.merge(node.attributes['href'].value).to_s
      }
    end
  end
end