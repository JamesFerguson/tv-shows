require 'spec_helper'
require 'parsers/nine_parser'

describe NineParser do
  before do
    FakeWeb.allow_net_connect = false
  end
  
  it "parses shows" do
    FakeWeb.register_uri(
      :get, 
      NineParser::SHOWS_URL, 
      :response => File.read(Rails.root + 'spec/fakeweb/pages/fixplay_ninemsn_com_au_tv_shows.htm')
    )
    NineParser.extract_shows.map(&:stringify_keys).should == 
      JSON.parse(File.read('spec/fakeweb/results/nine_parser_extract_shows.json'))
  end
  
  it "parses episodes" do
    show = TvShow.new(
      :name => "Winners and Losers",
      :url => "http://au.tv.yahoo.com/plus7/winners-and-losers/"
    )
    
    FakeWeb.register_uri(
      :get, 
      show.url,
      :response => File.read(Rails.root + 'spec/fakeweb/pages/nine_com_au_pages/.htm')
    )
    
    NineParser.extract_show(show).map(&:stringify_keys).should == 
      JSON.parse(File.read('spec/fakeweb/results/nine_com_au_results/.json'))
  end
end