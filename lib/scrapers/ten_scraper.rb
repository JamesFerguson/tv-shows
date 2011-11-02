require Rails.root.join 'lib/scrapers/base_scraper'
require Rails.root.join 'lib/scrapers/ten_xml_parser'

class TenScraper < BaseScraper
  PLAYLIST_IDS = {
    "Network10" => "41398",
    "OneHd" => "44571",
    "Eleven" => "43712",
    "Neighbours" => "41267",
    "Stargate" => "43967",
    "Masterchef" => "40328",
    "7PM Project" => "39688",
    "Ready Steady Cook" => "38735",
    "The Biggest Loser" => "?",
    "The Circle" => "?",
    "The Renovators" => "44821",
    "The Project TV" => "?"
  }
  def self.extract_show_urls(source_url)
    @@token = read_url(source_url).sub(/.*<token>(.*)<\/token>.*/m, '\1')

    playlist_id = PLAYLIST_IDS[source_url.scan(/key(?:=|%3D)movideo([^&%]+)/).flatten.first]
    ["http://api.v2.movideo.com/rest/playlist/#{playlist_id}?depth=4&token=#{@@token}&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate,isAdvertisement,imagePath"]
  end

  def self.extract_shows(source_url)
    playlist = TenXmlParser::Playlist.parse(read_url(source_url))

    unknown_external_links = filter_links(playlist.external_links)
    if unknown_external_links.any? && !ENV['IGNORE_EXT_LINKS']
      Rails.logger.info "Unknown external links found:\n#{unknown_external_links.inspect}"
      puts "Unknown external links found:\n#{unknown_external_links.inspect}"
    end

    playlists = filter_playlists(playlist)
    playlists.map do |playlist|
      {
        :name => munge_title(playlist.title),
        :data_url => "http://api.v2.movideo.com/rest/playlist/#{playlist.id}?depth=1&token=#{@@token}&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate,isAdvertisement,imagePath",
        :genre => playlist.genre
      }
    end
  end

  PLAY_URLS = {
    "Ten"               => "http://ten.com.au/watch-tv-episodes-online.htm",
    "OneHd"             => "http://one.com.au/video.htm",
    "Eleven"            => "http://eleven.com.au/catch-up-and-videos.htm",
    "Neighbours"        => "http://neighbours.com.au/video.htm?movideo_p=41267",
    "Masterchef"        => "http://www.masterchef.com.au/video.htm",
    "Ready Steady Cook" => "http://readysteadycook.ten.com.au/video.htm",
    "Stargate Universe" => "http://www.stargate-universe.com.au/full-episodes/",
    "The Biggest Loser" => "http://thebiggestloser.com.au/video.htm?",
    "The Circle"        => "http://ten.com.au/the-circle-video.htm?",
    "The Renovators"    => "http://therenovatorstv.com.au/video.htm?",
    "The 7PM Project"   => "http://7pmproject.com.au/video.htm",
    "The Project TV"    => "http://theprojecttv.com.au/video.htm"
  }
  def self.extract_episodes(show)
    play_url = PLAY_URLS[show.source.name]
    show_id = show.data_url.scan(/playlist\/(\d+)/).flatten.first

    playlist = TenXmlParser::Playlist.parse(read_url(show.data_url))

    show.update_attributes!(
      :homepage_url =>  "#{play_url}?movideo_p=#{show_id}",
      :image => playlist.image
    )

    index = 0
    playlist.media_list.media.map do |item|
      title = show.source.name == 'Neighbours' ? item.description : item.title

      next unless lead_clip?(title)

      index += 1

      {
        :name => munge_item_title(title),
        :url => "#{play_url}?movideo_p=#{show_id}&movideo_m=#{item.id}",
        :description => item.description,
        :image => item.image,
        :duration => item.duration,
        :ordering => index
      }
    end.compact
  end

  protected

  def self.filter_links(links)
    links.reject do |link|
      link =~ %r{http://(one.com.au|eleven.com.au)/} || PLAY_URLS.select { |source_name, url| link =~ /#{Regexp.escape(url)}/ }.any?
    end
  end

  def self.filter_playlists(playlist)
    playlist.child_playlists.playlists.reject { |playlist| playlist.media_list.media.empty? || playlist.media_list.media.first.title == "DUMMY MEDIA - IGNORE" }
  end

  def self.lead_clip?(title)
    part_num = title.gsub(/\s/, '').scan(/\((\d+)\/\d+\)/).flatten.first
    part_num ||= title.scan(/ p(\d+)$/).flatten.first
    part_num ||= title.scan(/- Part (\d+) -/).flatten.first
    part_num.nil? || part_num == '1'
  end

  def self.munge_item_title(title)
    title.sub(/\s+\([\d\s\/]+\)/, '').sub(/- Part (\d+) -/, '-')
  end

  def self.munge_title(title)
    title.sub(/ONE\s*\|\s*/, '').sub(/^((.*)\s*\|\s*\2)$/, '\2')
  end
end 
