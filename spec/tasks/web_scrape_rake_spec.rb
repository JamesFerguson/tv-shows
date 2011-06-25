require 'spec_helper'

describe "rake web:scrape" do
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
      @rake["web:scrape_shows"].invoke

      Source.where(:name => "Channel Nine").first.tv_shows.count.should == 38
      Source.where(:name => "Channel Seven").first.tv_shows.count.should == 60
      Source.where(:name => "ABC 1").first.tv_shows.count.should == 55
      Source.where(:name => "ABC 2").first.tv_shows.count.should == 36
      Source.where(:name => "ABC 3").first.tv_shows.count.should == 36
      Source.where(:name => "iView Originals").first.tv_shows.count.should == 8
      Source.where(:name => "SMH.tv").first.tv_shows.count.should == 174

      Source.count.should == 7
      TvShow.count.should == 407
    end
  end
end