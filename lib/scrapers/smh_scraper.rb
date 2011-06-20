require Rails.root + 'lib/scrapers/base_scraper'

class SmhScraper < BaseScraper
  def self.extract_shows(source_url)
    shows_url = URI.parse(source_url)
    
    page = Nokogiri::HTML(read_url(shows_url))

    subpage_urls = page.css("li.page a").map { |node| node.attributes['href'].value }.unshift(source_url)

    shows = []
    subpage_urls.each do |subpage_url|
      debugger
      page = Nokogiri::HTML(read_url(subpage_url))

      shows << page.css("ul.cN-listStoryTV h5 a").map do |node|
        {:name => node.text, :url => shows_url.merge(node.attributes['href'].value).to_s}
      end
    end

    shows.flatten!
  end
  
  def self.extract_episodes(show)
    show_url = URI.parse(show.url)
    page = Nokogiri::HTML(read_url(show_url))

    episodes = page.css("ul.cN-listStoryTV").first.css('li').map do |node|
      link = node.css('h5 a').first
      {
        :name => "#{node.xpath('p').first.text.gsub(/\s+/, ' ').strip}: #{link.text}",
        :url => show_url.merge(link['href']).to_s
      }
    end
  end
end