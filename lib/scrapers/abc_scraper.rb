require Rails.root.join('lib/scrapers/base_scraper')
require Rails.root.join('lib/scrapers/abc_xml_parser')

class AbcScraper < BaseScraper
  def self.extract_shows(source_url)
   items = AbcXmlParser::Item.parse(read_url(source_url)).group_by(&:thumbnail_url).values.map do |series|
      episode = series.first

      {
        :name => self.munge_title(episode.name, :series),
        :data_url => source_url,
        :homepage_url => episode.link,
        :image => episode.thumbnail_url,
        :genre => episode.genre.titlecase
      }
    end
  end

  def self.extract_episodes(show)
    items = AbcXmlParser::Item.parse(read_url(show.data_url)).group_by(&:thumbnail_url)[show.image]
    items = items.reverse.map.with_index do |episode, index|
      {
        :name => self.munge_title(episode.name, :episode),
        :url => episode.link,
        :description => episode.description,
        :duration => episode.duration,
        :image => episode.thumbnail_url,
        :ordering => index + 1
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
