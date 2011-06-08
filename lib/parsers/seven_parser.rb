class SevenParser
  SHOWS_URL = URI.parse('http://au.tv.yahoo.com/plus7/browse/')
  
  def self.extract_shows
    page = Nokogiri::HTML(SHOWS_URL.open)
    # debugger
    # 0
    shows = page.css("#atoz h3 a").map do |node|
      {:name => node.text, :url => SHOWS_URL.merge(node.attributes['href'].value).to_s}
    end
  end
  
  def self.extract_show(show)
    page = Nokogiri::HTML(open(show.url))
    
    episodes = page.css("ul#related-episodes .itemdetails h3 a").map do |node|
      {
        :name => node.children[3].text,
        :url => URI.parse(show.url).merge(node.attributes['href'].value).to_s
      }
    end
  end
end