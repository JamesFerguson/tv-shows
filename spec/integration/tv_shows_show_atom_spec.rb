require 'spec_helper'

describe "TvShowController#show, :format => :atom" do

  before do
    @source = Source.create!(
      :name => "Channel Twenty Seven",
      :url => "Source URL goes here"
    )
    @show = @source.tv_shows.create!(
      :name => "Name goes here"
    )
    @episode = @show.episodes.make

    visit tv_shows_url(:format => :atom)

    visit source_tv_show_url(@source, @show, :format => :atom)
  end

  it "has some content you'd expect to see" do
    page.should have_content("tag:www.example.com,2005:/sources/channel-twenty-seven/tv_shows/name-goes-here")
    page.should have_xpath('//feed/title', :text => 'Name goes here')

    page.should have_content("#{@episode.name}")
    page.should have_xpath("//link[@href='#{@episode.url}']")
  end

end