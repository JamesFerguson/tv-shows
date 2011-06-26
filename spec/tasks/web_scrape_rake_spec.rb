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
        "Channel Nine" => 38,
        "Channel Seven" => 60,
        "ABC 1" => 55,
        "ABC 2" => 36,
        "ABC 3" => 36,
        "iView Originals" => 8,
        "SMH.tv" => 174
      }

      @rake["web:scrape_shows"].invoke

      Source.all.each do |source|
        expectations[source.name].should_not be_nil

        source.tv_shows.count.should == expectations[source.name]
      end
      TvShow.count.should == expectations.values.sum
    end

    it "creates episodes" do
      @rake["web:scrape_shows"].invoke

      TvShow.active.each do |show|
        url = show.source.scraper_class == AbcScraper ? show.source.url : show.url
        source.scraper_class.should_receive(:read_url).with(URI.parse(url)).and_return(
            File.read(Rails.root + "spec/fakeweb/pages/#{fakewebize(url)}")
        )
      end

      @rake["web:scrape_episodes"].invoke

      Source.where(:name => "Channel Nine").first.episodes.count.should == 38
      Source.where(:name => "Channel Seven").first.episodes.count.should == 60
      Source.where(:name => "ABC 1").first.episodes.count.should == 55
      Source.where(:name => "ABC 2").first.episodes.count.should == 36
      Source.where(:name => "ABC 3").first.episodes.count.should == 36
      Source.where(:name => "iView Originals").first.episodes.count.should == 8
      Source.where(:name => "SMH.tv").first.episodes.count.should == 174

      Source.count.should == 7
      TvShow.count.should == 407
    end
  end
end