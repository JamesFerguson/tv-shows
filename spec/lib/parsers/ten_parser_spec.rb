require 'spec_helper'
require 'parsers/ten_parser'

describe TenParser do
  before do
    FakeWeb.allow_net_connect = false
  end
  
  it "parses shows" do
    FakeWeb.register_uri(
      :get, 
      TenParser::SHOWS_URL, 
      :response => File.read(Rails.root + 'spec/fakeweb/pages/ten_com_au_tv_shows.htm')
    )
    
    TenParser.extract_shows.should == 
        JSON.parse(File.read('spec/fakeweb/results/ten_parser_extract_shows.json'))
  end
end