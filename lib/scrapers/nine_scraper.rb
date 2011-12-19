require Rails.root + 'lib/scrapers/base_scraper'

class NineScraper < BaseScraper
  def self.extract_shows(source_url)
    shows_url = URI.parse(source_url)

    page = Nokogiri::HTML(read_url(source_url))

    shows = page.css("#showidx li").map do |node|
      {
        name: node.css('a .title').text,
        data_url: shows_url.merge(node.css('a').first.attributes['href'].value).to_s,
        homepage_url: shows_url.merge(node.css('a').first.attributes['href'].value).to_s,
        image: shows_url.merge(node.css('.showimage img').first.attributes['src'].value).to_s
      }
    end
  end

  def self.extract_episodes(show)
    show_url = URI.parse(show.data_url)
    page = Nokogiri::HTML(read_url(show.data_url))

    show_deets = page.css("div#feature_header")
    show.update_attributes!(
      description: show_deets.css('span.text').text,
      image: show_url.merge(show_deets.css('span.image img').first['src']).to_s,
      classification: nil,
      genre: show_deets.css('div.headertitle span').first.text.gsub(/[\w :-]+ \| /, ''),
    )

    episodes = page.css("#all_articles_index .tr").map.with_index do |node, index|
      {
        name: "Episode #{node.children[1].text}: #{node.css('.season_title').text}",
        url: show_url.merge(node.css('.watch_now_normal').first.attributes['href'].value).to_s,
        description: node.css('.season_desc').text,
        ordering: index + 1
      }
    end
  end
end
