require 'spec_helper'
require 'scrapers/ten_scraper'

describe TenScraper do
  before do
    FakeWeb.allow_net_connect = false
  end
  
  it "scrapes shows" do
    FakeWeb.register_uri(
      :get, 
      TenScraper::SHOWS_URL, 
      :response => File.read(Rails.root + 'spec/fakeweb/pages/ten_com_au_tv_shows.htm')
    )
    
    TenScraper.extract_shows.should == 
        JSON.parse(File.read('spec/fakeweb/results/ten_scraper_extract_shows.json'))
  end
end