require Rails.root + 'lib/scrapers/base_scraper'

class TenScraper < BaseScraper
  def self.extract_show_urls(source_url)
    @@token = read_url(source_url).sub(/.*<token>(.*)<\/token>.*/m, '\1')

    ["http://api.v2.movideo.com/rest/playlist/41398?depth=1&token=#{@@token}&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate"]
  end

  def self.extract_shows(source_url)
    page = Nokogiri::HTML(source_url)
    
    shows = page.css("li.item a").map do |node|
      [node.text, SHOWS_URL.merge(node.attributes['href'].value).to_s]
    end
  end
end
