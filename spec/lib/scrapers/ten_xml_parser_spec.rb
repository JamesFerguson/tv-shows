require 'spec_helper'
require Rails.root.join 'lib/scrapers/ten_xml_parser'

describe TenXmlParser do
  include ScraperHelper

  before(:each) do
    FakeWeb.allow_net_connect = false

    @ten_url = "http://api.v2.movideo.com/rest/playlist/41398?depth=4&token=abc&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate,isAdvertisement,defaultImage,imagePath"
    @ten_xml = File.read(Rails.root.join("spec/fakeweb/pages/#{fakewebize(@ten_url)}"))

    @playlist = TenXmlParser::Playlist.parse(@ten_xml)
  end

  it "finds external links" do
    @playlist.external_links.size.should == 23
    @playlist.external_links.select { |link| link =~ /one.com.au|eleven.com.au/ }.should be_any
  end
end
