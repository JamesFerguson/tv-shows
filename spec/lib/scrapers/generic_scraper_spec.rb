require 'spec_helper'

describe "any scraper" do
  before do
    FakeWeb.allow_net_connect = false
    load 'db/seeds.rb'
  end
  
  context "after faking scraper's shows indexes" do

    before do
      @sources = Source.all
      @sources.each do |source|
        require "scrapers/#{source.scraper.underscore}.rb"
        
        FakeWeb.register_uri(
          :get, 
          source.url, 
          :response => File.read(Rails.root + 
                                  "spec/fakeweb/pages/#{source.url.gsub(%r{/}, '^')}.htm")
        )
      end
    end

    Source.all.each do |source|
      it "does something" do
        source.scraper_class.extract_shows(source.url).map(&:stringify_keys).should == 
          JSON.parse(File.read(
            "spec/fakeweb/results/#{source.url.gsub(%r{/}, '^')}.json"
          ))        
      end
    end
    
    # it "scrapes shows" do
    #   source.scraper_class.extract_shows(@source_url).map(&:stringify_keys).should == 
    #     JSON.parse(File.read('spec/fakeweb/results/nine_scraper_extract_shows.json'))
    # end
  end
  
  # it "scrapes episodes" do
  #   show = TvShow.new(
  #     :name => "AFP",
  #     :url => "http://fixplay.ninemsn.com.au/afp"
  #   )
  #   
  #   FakeWeb.register_uri(
  #     :get, 
  #     show.url,
  #     :response => File.read(Rails.root + 'spec/fakeweb/pages/nine_com_au_pages/afp.htm')
  #   )
  #   
  #   NineScraper.extract_episodes(show).map(&:stringify_keys).should == 
  #     JSON.parse(File.read('spec/fakeweb/results/nine_com_au_results/afp_extract_show.json'))
  # end
end