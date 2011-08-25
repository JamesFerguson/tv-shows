require Rails.root + 'lib/scrapers/base_scraper'
require Rails.root + 'lib/scrapers/ten_xml_parser'

class TenScraper < BaseScraper
  def self.extract_show_urls(source_url)
    @@token = read_url(source_url).sub(/.*<token>(.*)<\/token>.*/m, '\1')

    ["http://api.v2.movideo.com/rest/playlist/41398?depth=1&token=#{@@token}&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate"]
  end

  def self.extract_shows(source_url)
    page = TenXmlParser::ChildPlaylist.parse(read_url(source_url)).first

    page.playlists.map do |playlist|
      {
        :name => munge_title(playlist.title),
        :url => "http://api.v2.movideo.com/rest/playlist/#{playlist.id}?depth=1&token=#{@@token}&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate"
      }
    end
  end
  def self.munge_title(title)
    title.sub(/\s*\|.*/, '')
  end
end 
