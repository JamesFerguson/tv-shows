class TenParser
  SHOWS_URL = URI.parse('http://ten.com.au/tvshows.htm')
  
  def self.extract_shows
    page = Nokogiri::HTML(SHOWS_URL.open)
    
    shows = page.css("li.item a").map do |node|
      [node.text, SHOWS_URL.merge(node.attributes['href'].value).to_s]
    end
  end
end