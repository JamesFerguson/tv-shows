require 'spec_helper'

describe "get :index, :format => :atom" do
  
  before do
    @source = Source.create!(
      :url => "Source URL goes here"
    )
    @show = TvShow.create!(
      :name => "Name goes here",
      :source => @source
    )
    visit tv_shows_url(:format => :atom)
  end
  
  it "has some content you'd expect to see" do
    page.should have_content("tag:www.example.com,2005:/tv_shows")
    page.should have_xpath('//feed/title', :text => 'TV Shows')

    page.should have_content("Name goes here (0 episodes)")
    page.should have_xpath("//link[@href='http://www.example.com/tv_shows/#{@show.id}.atom']")
    page.should have_content("Source URL goes here")
  end
  
end