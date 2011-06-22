require 'spec_helper'
require Rails.root + 'db/seeds.rb'
Source.all.each do |source|
  require "scrapers/#{source.scraper.underscore}.rb"
end

TvShow.destroy_all # rspec not deleting old records for some reason.
seed_tv_shows # Done here so we can do TvShow.all.each { |show| it "does something" do ... end }

describe "the scraper in question" do
  before do
    FakeWeb.allow_net_connect = false
  end
  
  context "after faking scrapers' source urls" do
    Source.all.each do |source|
      it "scrapes the index for #{source.name} ok" do
        source.scraper.constantize.should_receive(:read_url).with(URI.parse(source.url)).and_return(
            File.read(Rails.root + "spec/fakeweb/pages/#{fakewebize(source.url)}")
        )

        source.scraper_class.extract_shows(source.url).map(&:stringify_keys).should ==
          JSON.parse(File.read(
            "spec/fakeweb/results/#{fakewebize(source.url)}.json"
          ))        
      end
    end

    it "excludes slideshow, poll, etc when parsing channel nine" do
      source = Source.where(:name => "Channel Nine").first
      NineScraper.should_receive(:read_url).with(URI.parse(source.url)).and_return(
          File.read(Rails.root + "spec/fakeweb/pages/#{fakewebize(source.url)}")
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
    TvShow.all.each do |show|
      it "scrapes the episodes for #{show.name} ok" do
        show.source.scraper_class.should_receive(:read_url).and_return(
            File.read(Rails.root + "spec/fakeweb/pages/#{fakewebize(show.url)}")
        )

        show.source.scraper_class.extract_episodes(show).map(&:stringify_keys).should ==
          JSON.parse(File.read(
            "spec/fakeweb/results/#{fakewebize(show.url)}.json"
          ))
      end
    end
  end

  def fakewebize(url)
    url = url.gsub(%r{/}, '^')
    url = (url !~ /(\.html?|\.xml)$/ ? url + '.htm' : url)
  end
end