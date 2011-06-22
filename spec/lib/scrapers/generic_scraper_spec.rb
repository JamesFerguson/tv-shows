require 'spec_helper'
require Rails.root + 'db/seeds.rb'
Source.all.each do |source|
  require "scrapers/#{source.scraper.underscore}.rb"
end

TvShow.destroy_all # rspec not deleting old records for some reason.
seed_tv_shows # Done here so we can do TvShow.all.each { |show| it "does something" do ... end }

describe "any scraper" do
  before do
    FakeWeb.allow_net_connect = false
  end
  
  context "after faking scrapers' source urls" do
    Source.all.each do |source|
      it "scrapes the index for #{source.name} ok" do
        source_url = source.url.gsub(%r{/}, '^')
        source_url = (source_url !~ /(\.html?|\.xml)$/ ? source_url + '.htm' : source_url)
        source.scraper.constantize.should_receive(:read_url).with(URI.parse(source.url)).and_return(
            File.read(Rails.root + "spec/fakeweb/pages/#{source_url}")
        )

        source.scraper_class.extract_shows(source.url).map(&:stringify_keys).should ==
          JSON.parse(File.read(
            "spec/fakeweb/results/#{source.url.gsub(%r{/}, '^')}.json"
          ))        
      end
    end

    it "excludes slideshow, poll, etc when parsing channel nine" do
      source = Source.where(:name => "Channel Nine").first
      source_url = source.url.gsub(%r{/}, '^')
      source_url = (source_url !~ /(\.html?|\.xml)$/ ? source_url + '.htm' : source_url)
      NineScraper.should_receive(:read_url).with(URI.parse(source.url)).and_return(
          File.read(Rails.root + "spec/fakeweb/pages/#{source_url}")
      )

      NineScraper.extract_shows(
        source.url
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
        show.source.scraper_class.stub(:read_url).and_return(
            File.read(Rails.root + "spec/fakeweb/pages/#{show_url}")
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