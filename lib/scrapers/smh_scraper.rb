class SmhScraper
  def self.extract_shows(source_url)
    shows_url = URI.parse(source_url)
    
    page = Nokogiri::HTML(shows_url.open)
    
    shows = page.css("ul.cN-listStoryTV h5 a").map do |node|
      {:name => node.text, :url => shows_url.merge(node.attributes['href'].value).to_s}
    end
  end
  
  def self.extract_episodes(show)
    page = Nokogiri::HTML(open(show.url))
    show_url = URI.parse(show.url)
    
    episodes = page.css("ul.cN-listStoryTV").first.css('li').map do |node|
      link = node.css('h5 a').first
      {
        :name => "#{node.xpath('p').first.text.gsub(/\s+/, ' ').strip}: #{link.text}",
        :url => show_url.merge(link['href']).to_s
      }
    end
  end
end