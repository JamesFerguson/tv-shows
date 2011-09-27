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

    show_deets = page.css("div.mod.tv-plus7-info p")
    show.update_attributes!(
      :description => show_deets[1].text,
      :image => show_deets.css('img').first['src'],
      :classification => show_deets.css('strong').first.text,
      :genre => show_deets.css('strong').last.text,
    )

    episodes = page.css("ul#related-episodes .itemdetails").reverse.map.with_index do |node, index|
      title = node.css('h3 a').first
      {
        :name => title.children[3].text.squish,
        :url => show_url.merge(title.attributes['href'].value).to_s,
        :description => node.css('p').first.text,
        :ordering => index + 1
      }
    end
  end
end
