class AbcScraper
  def self.extract_shows(source_url)
    shows_url = URI.parse(source_url)
    
    page = Nokogiri::XML(shows_url.open)
    
    shows = {}
    page.xpath('/rss/channel/item').map do |node|
      next if shows[node.xpath('media:thumbnail[@url]/@url').first.value]
      
      shows[node.xpath('media:thumbnail[@url]/@url').first.value] = {
        :name => self.munge_title(node.xpath('title').text, :series),
        :url => node.xpath('media:thumbnail[@url]/@url').first.value
      }
    end

    shows.values
  end
  
  def self.extract_episodes(show)
    page = Nokogiri::XML(open(show.source.url))
    
    episodes = 
      page.xpath("/rss/channel/item[media:thumbnail[@url = '#{show.url}']]").map do |node|
      {
        :name => self.munge_title(node.xpath('title').text, :episode),
        :url => URI.parse(show.url).merge(node.xpath('link').text).to_s
      }
    end
  end
  
  private
  
  SUBS = {
    :series => [%r{ (\d\d/\d\d/\d\d|Episode \d+|2011).*}, ''],
    :episode => [%r{.*(\d\d/\d\d/\d\d.*|Episode \d+.*|2011)}, '\1']
  }
  def self.munge_title(title, type)
    title.gsub(SUBS[type].first, SUBS[type].last)
  end
end