require 'spec_helper'

describe "each scraper" do
  include FakewebHelper

  before(:all) do
    FakeWeb.allow_net_connect = false
    seed_sources
    seed_tv_shows
  end

  after(:all) do
    Source.destroy_all
    TvShow.destroy_all
  end
  
  context "after faking scrapers' source urls" do
    it "scrapes the index for each source ok" do
      Source.all.each do |source|
        show_urls = source.scraper_class.extract_show_urls(source.url)

        show_urls.each do |url|
          source.scraper_class.should_receive(:read_url).with(url).and_return(
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
      NineScraper.should_receive(:read_url).with(source.url).and_return(
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
  
  context "scrapes tv_shows ok" do
    it "has a tv_show seeded" do
      Source.all.each do |source|
        source.tv_shows.count.should > 0
      end
    end

    it "scrapes the episodes for each show ok" do
      Source.all.each do |source|
        show = source.tv_shows.first
        url = source.scraper_class == AbcScraper ? source.url : show.url

        show.source.scraper_class.should_receive(:read_url).and_return(
            File.read(Rails.root + "spec/fakeweb/pages/#{fakewebize(url)}")
        )

        show.source.scraper_class.extract_episodes(show).map(&:stringify_keys).should ==
          JSON.parse(File.read(
            "spec/fakeweb/results/#{fakewebize(show.url)}.json"
          ))
      end
    end
  end
end