require 'spec_helper'

describe "rake web:scrape_*" do
  include FakewebHelper

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
      # Some scrapers call read_url for extract_show_urls
      Source.where("sources.scraper IN ('SmhScraper', 'TenScraper', 'TenMicroSiteScraper')").each do |source|
        if (first_scrapes & [source.scraper, source.name]).any?
          `curl --silent -L #{Shellwords.shellescape(source.url)} >#{Shellwords.shellescape((Rails.root + "spec/fakeweb/pages/#{fakewebize(source.url)}").to_s)}`
        end

        source.scraper.constantize.should_receive(:read_url).with(source.url).exactly(2).times.and_return(
          File.read(Rails.root + "spec/fakeweb/pages/#{fakewebize(source.url)}")
        )
      end

      Source.all.each do |source|
        show_urls = source.scraper_class.extract_show_urls(source.url)

        show_urls.each do |url|
          if (first_scrapes & [source.scraper, source.name]).any?
            `curl --silent -L #{Shellwords.shellescape(url)} >#{Shellwords.shellescape((Rails.root + "spec/fakeweb/pages/#{fakewebize(url)}").to_s)}`
          end

          source.scraper_class.should_receive(:read_url).with(url).and_return(
            File.read(Rails.root + "spec/fakeweb/pages/#{fakewebize(url)}")
          )
        end
      end
    end

    it "should create some shows" do
      @rake["web:scrape_shows"].invoke

      expectations = {
        "Yahoo Plus7" => 71,
        "NineMSN Fixplay" => 33,
        "ABC 1" => 55,
        "ABC 2" => 35,
        "ABC 3" => 41,
        "iView Originals" => 7,
        "SMH.tv" => 174,
        "Ten" => 20,
        "OneHd" => 33,
        "Eleven" => 17,
        "Neighbours" => 1
      }

      Source.all.each do |source|
        expectations[source.name].should_not be_nil
        source.tv_shows.count.should == expectations[source.name]
      end

      TvShow.count.should == expectations.values.sum
      Source.count.should == expectations.count
    end

    it "creates episodes" do
      @rake["web:scrape_shows"].execute # runs even if already run before, won't do dependencies

      TvShow.all.each do |show|
        url = show.source.scraper_class == AbcScraper ? show.source.url : show.url

        if (first_scrapes & [show.source.scraper, show.source.name]).any?
          `curl --silent -L #{Shellwords.shellescape(url)} >#{Shellwords.shellescape((Rails.root + "spec/fakeweb/pages/web_scrape_rake_spec_pages/#{fakewebize(url)}").to_s)}`
        end
        show.source.scraper_class.should_receive(:read_url).with(url).and_return(
            File.read(Rails.root + "spec/fakeweb/pages/web_scrape_rake_spec_pages/#{fakewebize(url)}")
        )
      end

      @rake["web:scrape_episodes"].invoke

      expectations = {
        "Yahoo Plus7" => 521,
        "NineMSN Fixplay" => 227,
        "ABC 1" => 130,
        "ABC 2" => 66,
        "ABC 3" => 271,
        "iView Originals" => 25,
        "SMH.tv" => 655,
        "Ten" => 216,
        "OneHd" => 500,
        "Eleven" => 195,
        "Neighbours" => 5
      }

      Source.all.each do |source|
        expectations[source.name].should_not be_nil

        source.episodes.active.count.should == expectations[source.name]
      end
      Episode.active.count.should == expectations.values.sum
      Source.count.should == expectations.count
    end
  end
end

def first_scrapes
  (ENV['FIRST_SCRAPE'] || '').split(',')
end
