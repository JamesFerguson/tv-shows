require Rails.root + 'lib/scrapers/base_scraper'

class SevenScraper < BaseScraper
  def self.extract_shows(source_url)
    shows_url = URI.parse(source_url)

    page = Nokogiri::HTML(read_url(source_url))

    shows = page.css("#atoz h3 a").map do |node|
      {
        :name => node.text,
        :data_url => shows_url.merge(node.attributes['href'].value).to_s,
        :homepage_url => shows_url.merge(node.attributes['href'].value).to_s
      }
    end
  end

  def self.extract_episodes(show)
    show_url = URI.parse(show.data_url)
    page = Nokogiri::HTML(read_url(show.data_url))

    show_deets = page.css(".tv-plus7-info")
    show.update_attributes!(
      :description => show_deets.css('.summary').text,
      :image => show_deets.css('.tv-plus7-links .site-logo img').first['src'],
      :classification => show_deets.css('strong').first.text,
      :genre => show_deets.css('strong').last.text,
    )

    episodes = page.css("#related-episodes li").reverse.map.with_index do |node, index|
      {
        name: node.css('.subtitle').first.text.squish,
        url: show_url.merge(node.css('a.vidimg').first.attributes['href'].value).to_s,
        image: node.css('img.listimg').first['src'],
        description: node.css('.itemdetails p').text.squish,
        ordering: index + 1
      }
    end
  end
end
