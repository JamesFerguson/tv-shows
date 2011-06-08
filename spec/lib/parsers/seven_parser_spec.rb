require 'spec_helper'
require 'parsers/seven_parser'

describe SevenParser do
  before do
    FakeWeb.allow_net_connect = false
  end
  
  it "parses shows" do
    FakeWeb.register_uri(
      :get, 
      SevenParser::SHOWS_URL, 
      :response => File.read(Rails.root + 'spec/fakeweb/pages/seven_com_au_tv_shows.htm')
    )

    SevenParser.extract_shows.map(&:stringify_keys).should == 
        JSON.parse(File.read('spec/fakeweb/results/seven_parser_extract_shows.json'))
  end
  
  it "parses episodes" do
    show = TvShow.new(
      :name => "Winners and Losers",
      :url => "http://au.tv.yahoo.com/plus7/winners-and-losers/"
    )
    
    FakeWeb.register_uri(
      :get, 
      show.url,
      :response => File.read(Rails.root + 'spec/fakeweb/pages/seven_com_au_pages/winners-and-losers_page.htm')
    )

    SevenParser.extract_show(show).map(&:stringify_keys).should == 
      JSON.parse(
        File.read(
          'spec/fakeweb/results/seven_com_au_results/winners-and-losers_extract_show.json'
        )
      )
  end
end