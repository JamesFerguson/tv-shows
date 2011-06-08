class NineScraper
  def self.extract_shows(source_url)
    shows_url = URI.parse(source_url)
    
    page = Nokogiri::HTML(shows_url.open)
    
    shows = page.css("a.linkItem").map do |node|
      {:name => node.text, :url => shows_url.merge(node.attributes['href'].value).to_s}
    end
  end
  
  def self.extract_show(show)
    page = Nokogiri::HTML(open(show.url))
    
    shows = page.css("ul#related-episodes .itemdetails h3 a").map do |node|
      {
        :name => node.children[3].text,
        :url => URI.parse(show.url).merge(node.attributes['href'].value).to_s
      }
    end
  end
end