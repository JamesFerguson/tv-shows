require Rails.root + 'lib/scrapers/base_scraper'

class SevenScraper < BaseScraper
  def self.extract_shows(source_url)
    shows_url = URI.parse(source_url)

    page = Nokogiri::HTML(read_url(source_url))

    shows = page.css("#atoz h3 a").map do |node|
      {:name => node.text, :url => shows_url.merge(node.attributes['href'].value).to_s}
    end
  end

  def self.extract_episodes(show)
    show_url = URI.parse(show.url)
    page = Nokogiri::HTML(read_url(show.url))

    show_deets = page.css("div.mod.tv-plus7-info p")
    show.update_attributes!(
      :description => show_deets[1].text,
      :image => show_deets.css('img').first['src'],
      :classification => show_deets.css('strong').first.text,
      :genre => show_deets.css('strong').last.text,
    )

    episodes = page.css("ul#related-episodes .itemdetails h3 a").reverse.map.with_index do |node, index|
      {
        :name => node.children[3].text,
        :url => show_url.merge(node.attributes['href'].value).to_s,
        :ordering => index + 1
      }
    end
  end
end
