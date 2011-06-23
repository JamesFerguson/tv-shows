require 'spec_helper'

Source.all.each do |source|
  require "scrapers/#{source.scraper.underscore}.rb"
end

TvShow.destroy_all # rspec not deleting old records for some reason.
seed_tv_shows # Done here so we can do TvShow.all.each { |show| it "does something" do ... end }

describe "the scraper in question" do
  include FakewebHelper

  before do
    FakeWeb.allow_net_connect = false
  end
  
  context "after faking scrapers' source urls" do
    Source.all.each do |source|
      it "scrapes the index for #{source.name} ok" do
        show_urls = source.scraper_class.extract_show_urls(source.url)

        show_urls.each do |url|
          source.scraper_class.should_receive(:read_url).with(URI.parse(url)).and_return(
              File.read(Rails.root + "spec/fakeweb/pages/#{fakewebize(url)}")
          )
        end

        shows = []
        show_urls.each do |url|
          shows << source.scraper_class.extract_shows(url).map(&:stringify_keys)
        end
        shows.flatten.should ==
          JSON.parse(File.read("spec/fakeweb/results/#{fakewebize(source.url)}.json"))
      end
    end

    it "excludes slideshow, poll, etc when parsing channel nine" do
      source = Source.where(:name => "Channel Nine").first
      NineScraper.should_receive(:read_url).with(URI.parse(source.url)).and_return(
          File.read(Rails.root + "spec/fakeweb/pages/#{fakewebize(source.url)}")
      )

      NineScraper.extract_shows(
        NineScraper.extract_show_urls(source.url).first
      ).map do |show_data|
        URI.parse(show_data[:url]).host
      end.
        uniq.should == ["fixplay.ninemsn.com.au"]
    end
  end
  
  context "tv_shows scrape ok" do
    Source.all.each do |source|
      it "has a tv_show seeded" do
        source.tv_shows.count.should > 0
      end

      next unless source.tv_shows.first

      it "scrapes the episodes for #{source.tv_shows.first.name} ok" do
        show = source.tv_shows.first
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
end