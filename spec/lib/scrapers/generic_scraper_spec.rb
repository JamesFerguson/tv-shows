require 'spec_helper'
require Rails.root + 'db/seeds.rb'

# Done here so we can do TvShow.all.each { |show| it "does something" do ... end }
TvShow.destroy_all # rspec not deleting old records for some reason.
Source.where(:name => "Channel Nine").first.tv_shows.make(:name => "AFP", :url => "http://fixplay.ninemsn.com.au/afp")

Source.where(:name => "Channel Seven").first.tv_shows.make(
  :name => "Winners and Losers",
  :url => "http://au.tv.yahoo.com/plus7/winners-and-losers/"
)

Source.where(:name => "SMH.tv").first.tv_shows.make(
  :name => "Baby Baby",
  :url => "http://www.smh.com.au/tv/show/baby-baby-20110308-1bm6s.html"
)

describe "any scraper" do
  before do
    FakeWeb.allow_net_connect = false
    @sources = Source.all
  end
  
  context "after faking scrapers' source urls" do
    before do
      @sources.each do |source|
        require "scrapers/#{source.scraper.underscore}.rb"
        
        source_url = source.url.gsub(%r{/}, '^')
        source_url = (source_url !~ /(\.html?|\.xml)$/ ? source_url + '.htm' : source_url)
        FakeWeb.register_uri(
          :get, 
          source.url, 
          :response => File.read(Rails.root + 
                                  "spec/fakeweb/pages/#{source_url}")
        )
      end
    end

    Source.all.each do |source|
      it "scrapes the index for #{source.name} ok" do
        source.scraper_class.extract_shows(source.url).map(&:stringify_keys).should == 
          JSON.parse(File.read(
            "spec/fakeweb/results/#{source.url.gsub(%r{/}, '^')}.json"
          ))        
      end
    end

    it "excludes slideshow, poll, etc when parsing channel nine" do
      NineScraper.extract_shows(
                                Source.where(:name => "Channel Nine").first.url
      ).map do |show_data|
        URI.parse(show_data[:url]).host
      end.
        uniq.should == ["fixplay.ninemsn.com.au"]
    end
  end
  
  context "after populating tv_shows and faking their urls" do
    before(:each) do
      TvShow.all.each do |show|
        require "scrapers/#{show.source.scraper.underscore}.rb"

        show_url = show.url.gsub(%r{/}, '^')
        show_url = (show_url !~ /(\.html?|\.xml)$/ ? show_url + '.htm' : show_url)
        FakeWeb.register_uri(
          :get, 
          show.url, 
          :response => File.read(Rails.root + 
                                  "spec/fakeweb/pages/#{show_url}")
        )
      end
    end

    TvShow.all.each do |show|
      it "scrapes the episodes for #{show.name} ok" do
        show.source.scraper_class.extract_episodes(show).map(&:stringify_keys).should == 
          JSON.parse(File.read(
            "spec/fakeweb/results/#{show.url.gsub(%r{/}, '^')}.json"
          ))
      end
    end
  end
end