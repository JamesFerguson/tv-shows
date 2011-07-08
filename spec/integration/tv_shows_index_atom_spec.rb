require 'spec_helper'

describe "get :index, :format => :atom" do
  
  before do
    @source = Source.create!(
      :name => "Channel Twenty Seven",
      :url => "Source URL goes here"
    )
    @show = TvShow.create!(
      :name => "Name goes here",
      :source => @source
    )
    visit tv_shows_url(:format => :atom)
  end
  
  it "has some content you'd expect to see" do
    feed = AtomFeedMapping::Feed.parse(page.body)
    feed.id.should == "tag:www.example.com,2005:/tv_shows"
    feed.title.should == 'TV Shows'
    feed.updated.should >= 1.minute.ago

    URI.parse(feed.link.first.href).path.should == ''
    URI.parse(feed.link.last.href).path.should == '/tv_shows.atom'


    page.should have_content("Name goes here (0 episodes)")
    page.should have_xpath("//link[@href='http://www.example.com/sources/#{@source.friendly_id}/tv_shows/#{@show.friendly_id}.atom']")
    page.should have_content("Source URL goes here")
  end
  
end