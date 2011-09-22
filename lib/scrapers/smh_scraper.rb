require Rails.root + 'lib/scrapers/base_scraper'

class SmhScraper < BaseScraper
  def self.extract_show_urls(source_url)
    page = Nokogiri::HTML(read_url(source_url))

    show_urls = page.css("li.page a").map { |node| node.attributes['href'].value }.unshift(source_url)
  end

  def self.extract_shows(source_url)
    page = Nokogiri::HTML(read_url(source_url))
    source_url = URI.parse(source_url)

    shows = page.css("ul.cN-listStoryTV h5 a").map do |node|
      {
        :name => node.text,
        :url => source_url.merge(node.attributes['href'].value).to_s
      }
    end
  end

  def self.extract_episodes(show)
    show_url = URI.parse(show.url)
    page = Nokogiri::HTML(read_url(show.url))

    show.update_attributes!(
      :image => page.css('div.wrapShow img').first['src'],
      :genre => (page.css('div.wof p.more a').first || page.css('div.cS-rateMetadata dd a')[1]).text,
      :description => (page.css('div.wof p').last || page.css('div.cS-rateMetadata dd')[2]).text
    )

    episodes = page.css("ul.cN-listStoryTV").first.css('li').reverse.map.with_index do |node, index|
      link = node.css('h5 a').first
      {
        :name => "#{node.xpath('p').first.text.gsub(/\s+/, ' ').strip}: #{link.text}",
        :url => show_url.merge(link['href']).to_s,
        :ordering => index + 1
      }
    end
  end
end
