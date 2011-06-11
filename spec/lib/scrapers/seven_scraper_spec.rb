require 'spec_helper'
require 'scrapers/seven_scraper'

describe SevenScraper do
  before do
    FakeWeb.allow_net_connect = false
  end
  
  it "scrapes shows" do
    load 'db/seeds.rb'
    source_url = Source.where(:name => "Channel Seven").first.url
    FakeWeb.register_uri(
      :get, 
      source_url,
      :response => File.read(Rails.root + 'spec/fakeweb/pages/seven_com_au_tv_shows.htm')
    )

    SevenScraper.extract_shows(source_url).map(&:stringify_keys).should == 
        JSON.parse(File.read('spec/fakeweb/results/seven_scraper_extract_shows.json'))
  end
  
  it "scrapes episodes" do
    show = TvShow.new(
      :name => "Winners and Losers",
      :url => "http://au.tv.yahoo.com/plus7/winners-and-losers/"
    )
    
    FakeWeb.register_uri(
      :get, 
      show.url,
      :response => File.read(Rails.root + 'spec/fakeweb/pages/seven_com_au_pages/winners-and-losers_page.htm')
    )

    SevenScraper.extract_episodes(show).map(&:stringify_keys).should == 
      JSON.parse(
        File.read(
          'spec/fakeweb/results/seven_com_au_results/winners-and-losers_extract_show.json'
        )
      )
  end
end