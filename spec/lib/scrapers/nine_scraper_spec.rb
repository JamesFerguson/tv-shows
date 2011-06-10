require 'spec_helper'
require 'scrapers/nine_scraper'

describe NineScraper do
  before do
    FakeWeb.allow_net_connect = false
  end
  
  context "after hitting nine's shows index" do
    before do
      load 'db/seeds.rb'
      @source_url = Source.where(:name => "Channel Nine").first.url
      
      FakeWeb.register_uri(
        :get, 
        @source_url, 
        :response => File.read(Rails.root + 'spec/fakeweb/pages/fixplay_ninemsn_com_au_tv_shows.htm')
      )
    end
    
    it "scrapes shows" do
      NineScraper.extract_shows(@source_url).map(&:stringify_keys).should == 
        JSON.parse(File.read('spec/fakeweb/results/nine_scraper_extract_shows.json'))
    end
  
    it "excludes slideshow, poll, etc" do
      NineScraper.extract_shows(@source_url).map do |show_data|
        URI.parse(show_data[:url]).host
      end.
      uniq.should == ["fixplay.ninemsn.com.au"]
    end
  end
  
  it "scrapes episodes" do
    show = TvShow.new(
      :name => "AFP",
      :url => "http://fixplay.ninemsn.com.au/afp"
    )
    
    FakeWeb.register_uri(
      :get, 
      show.url,
      :response => File.read(Rails.root + 'spec/fakeweb/pages/nine_com_au_pages/afp.htm')
    )
    
    NineScraper.extract_show(show).map(&:stringify_keys).should == 
      JSON.parse(File.read('spec/fakeweb/results/nine_com_au_results/afp_extract_show.json'))
  end
end