require 'spec_helper'

describe "TvShowController#show, format: :atom" do

  before(:all) do
    Source.destroy_all

    @source = Source.create!(
      name: "Channel Twenty Seven",
      url: "Source URL goes here"
    )
    @show = @source.tv_shows.create!(
      name: "Name goes here"
    )
    @show2 = @source.tv_shows.create!(
      name: "Name2 goes here"
    )
    @episode = @show.episodes.make!
  end

  it "has some content you'd expect to see" do
    visit source_tv_show_url(@source, @show, format: :atom)
    feed = AtomFeedMapping::Feed.parse(page.body)

    feed.id.should == "tag:www.example.com,2005:/sources/channel-twenty-seven/tv_shows/name-goes-here"
    feed.title.should == 'Name goes here'

    episode = feed.entries.first
    episode.title.should == "001 #{@episode.name}"
    episode.link.href.should == @episode.url
  end

  it "handles shows with no episodes" do
    visit source_tv_show_url(@source, @show2, format: :atom)
    feed = AtomFeedMapping::Feed.parse(page.body)

    feed.id.should == "tag:www.example.com,2005:/sources/channel-twenty-seven/tv_shows/name2-goes-here"
    feed.title.should == 'Name2 goes here'
  end
end
