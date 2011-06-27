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
      Source.all.each do |source|
        show_urls = source.scraper_class.extract_show_urls(source.url)

        show_urls.each.with_index do |url, index|
          expectation = source.scraper_class.should_receive(:read_url).with(URI.parse(url))

          expectation.twice if index == 0 && show_urls.count > 1 # pagination double scrapes first page

          expectation.and_return(
              File.read(Rails.root + "spec/fakeweb/pages/#{fakewebize(url)}")
          )
        end
      end
    end

    it "should create some shows" do
      expectations = {
        "Channel Seven" => 71,
        "Channel Nine" => 33,
        "ABC 1" => 55,
        "ABC 2" => 35,
        "ABC 3" => 41,
        "iView Originals" => 7,
        "SMH.tv" => 174
      }

      @rake["web:scrape_shows"].invoke

      Source.all.each do |source|
        expectations[source.name].should_not be_nil

        source.tv_shows.count.should == expectations[source.name]
      end

      TvShow.count.should == expectations.values.sum
      Source.count.should == expectations.count
    end

    it "creates episodes" do
      @rake["web:scrape_shows"].invoke

      TvShow.all.each do |show|
        url = show.source.scraper_class == AbcScraper ? show.source.url : show.url

        show.source.scraper_class.should_receive(:read_url).with(URI.parse(url)).and_return(
            File.read(Rails.root + "spec/fakeweb/pages/web_scrape_rake_spec_pages/#{fakewebize(url)}")
        )
      end

      @rake["web:scrape_episodes"].invoke

      expectations = {
        "Channel Nine" => 38,
        "Channel Seven" => 60,
        "ABC 1" => 55,
        "ABC 2" => 36,
        "ABC 3" => 36,
        "iView Originals" => 8,
        "SMH.tv" => 174
      }
      puts Source.all.map {|s| "\"#{s.name}\" => #{s.episodes.count}," }

      Source.all.each do |source|
        expectations[source.name].should_not be_nil

        source.episodes.count.should == expectations[source.name]
      end
      Episode.count.should == expectations.values.sum
      Source.count.should == expectations.count
    end
  end
end