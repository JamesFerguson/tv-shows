require 'spec_helper'

describe "rake web:scrape_*" do
  include ScraperHelper

  before(:all) do
    FakeWeb.allow_net_connect = false

    @rake = Rake.application

    seed_sources
  end

  after(:all) do
    Source.destroy_all
  end

  context "after faking pages for all source urls" do
    before(:each) do
      Source.all.each do |source|
        fake_extract_shows_pages(source, 2)
      end
    end

    it "should create some shows" do
      @rake["web:scrape_shows"].invoke

      expectations = {
        "Yahoo Plus7" => 55,
        "NineMSN Fixplay" => 19,
        "ABC 1" => 74,
        "ABC 2" => 32,
        "ABC 3" => 54,
        "iView Originals" => 9,
        "SMH.tv" => 288,
        "Ten" => 35,
        "OneHd" => 20,
        "Eleven" => 14,
        "Neighbours" => 1
      }

      Source.all.reduce({}) { |results, source| results[source.name] = source.tv_shows.count; results }.should == expectations

      TvShow.count.should == expectations.values.sum
      Source.count.should == expectations.count
    end

    it "creates episodes" do
      @rake["web:scrape_shows"].execute # runs even if already run before, won't do dependencies

      TvShow.all.each do |show|
        url = show.data_url

        unless show.source.scraper == 'AbcScraper'
          download_page_if_new(show.source, url)
          fake_page(show.source.scraper_class, url)
        end
      end

      @rake["web:scrape_episodes"].invoke

      expectations = {
        "Yahoo Plus7" => 248,
        "NineMSN Fixplay" => 215,
        "ABC 1" => 154,
        "ABC 2" => 64,
        "ABC 3" => 283,
        "iView Originals" => 17,
        "SMH.tv" => 931,
        "Ten" => 301,
        "OneHd" => 197,
        "Eleven" => 197,
        "Neighbours" => 10
      }

      Source.all.reduce({}) { |results, source| results[source.name] = source.episodes.active.count; results }.should == expectations

      Episode.active.count.should == expectations.values.sum
      Source.count.should == expectations.count
    end
  end
end
