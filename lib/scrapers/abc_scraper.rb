require Rails.root + 'lib/scrapers/base_scraper'

class AbcScraper < BaseScraper
  def self.extract_shows(source_url)
    page = Nokogiri::XML(read_url(source_url))

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
    page = Nokogiri::XML(read_url(show.source.url))
    show_url = URI.parse(show.url)
    
    episodes = 
      page.xpath("/rss/channel/item[media:thumbnail[@url = '#{show.url}']]").map.with_index do |node, index|
      {
        :name => self.munge_title(node.xpath('title').text, :episode),
        :url => show_url.merge(node.xpath('link').text).to_s,
        :ordering => index
      }
    end
  end
  
  protected
  
  SUBS = {
    :series => [%r{ (\d\d/\d\d/\d\d|Episode \d+|2011).*}, ''],
    :episode => [%r{.*(\d\d/\d\d/\d\d|Episode \d+|2011)}, '\1']
  }
  def self.munge_title(title, type)
    title.gsub(SUBS[type].first, SUBS[type].last)
  end
end