require 'spec_helper'

describe "get :index, :format => :atom" do
  
  before do
    @source = Source.create!(
      :name => "Channel Twenty Seven",
      :url => "http://www.channeltwentyseven.com"
    )
    @show1 = @source.tv_shows.create!(
      :name => "Show 1",
      :url => 'http://www.channeltwentyseven.com/show-1'
    )
    @episode1 = @show1.episodes.create!(
      :name => "Episode 1",
      :url => 'http://www.channeltwentyseven.com/show-1/episode-1'
    )
    @episode2 = @show1.episodes.create!(
      :name => "Episode 2",
      :url => 'http://www.channeltwentyseven.com/show-1/episode-2'
    )
    @show2 = @source.tv_shows.create!(
      :name => "Show 2",
      :url => 'http://www.channeltwentyseven.com/show-2'
    )
    @episode15 = @show2.episodes.create!(
      :name => "Episode 15",
      :url => 'http://www.channeltwentyseven.com/show-2/episode-15'
    )

    visit tv_shows_url(:format => :atom)
  end
  
  it "has some content you'd expect to see" do
    feed = AtomFeedMapping::Feed.parse(page.body)
    feed.id.should == "tag:www.example.com,2005:/tv_shows"
    feed.title.should == 'TV Shows'
    feed.updated.should >= 1.minute.ago

    alt_link = feed.links.first
    alt_link.rel.should == 'alternate'
    alt_link.type.should == 'text/html'
    alt_link.href.should == 'http://www.example.com'

    self_link = feed.links.last
    self_link.rel.should == 'self'
    self_link.type.should == 'application/atom+xml'
    self_link.href.should == 'http://www.example.com/tv_shows.atom'

    
    show1 = feed.entries.first
    show1.id.should == "tag:www.example.com,2005:TvShow/#{@show1.id}"
    show1.title.should == '[Channel Twenty Seven] Show 1'
    show1.content.should == <<-HTML
<h2>Show 1 (2 episodes)</h2>
<p><a href="http://www.example.com/sources/channel-twenty-seven/tv_shows/show-1.atom">Subscribe</a> to the Show 1 <a href="http://www.example.com/sources/channel-twenty-seven/tv_shows/show-1.atom">episodes feed</a>.</p>
<p>See the <a href="http://www.channeltwentyseven.com/show-1">Show 1 homepage</a>.</p>
<p>Jump to an episode:
  <ul>
    <li><a href="http://www.channeltwentyseven.com/show-1/episode-1">Episode 1</a></li>
    <li><a href="http://www.channeltwentyseven.com/show-1/episode-2">Episode 2</a></li>
  </ul>
</p>
    HTML
    show1.author_name.should == '<a href="http://www.channeltwentyseven.com">Channel Twenty Seven</a>'

    show1_link = show1.link
    show1_link.rel.should == 'alternate'
    show1_link.type.should == 'text/html'
    show1_link.href.should == 'http://www.example.com/sources/channel-twenty-seven/tv_shows/show-1.atom'


    show2 = feed.entries.last
    show2.id.should == "tag:www.example.com,2005:TvShow/#{@show2.id}"
    show2.title.should == '[Channel Twenty Seven] Show 2'
    show2.content.should == <<-HTML
<h2>Show 2 (1 episodes)</h2>
<p><a href="http://www.example.com/sources/channel-twenty-seven/tv_shows/show-2.atom">Subscribe</a> to the Show 2 <a href="http://www.example.com/sources/channel-twenty-seven/tv_shows/show-2.atom">episodes feed</a>.</p>
<p>See the <a href="http://www.channeltwentyseven.com/show-2">Show 2 homepage</a>.</p>
<p>Jump to an episode:
  <ul>
    <li><a href="http://www.channeltwentyseven.com/show-2/episode-15">Episode 15</a></li>
  </ul>
</p>
    HTML
    show1.author_name.should == '<a href="http://www.channeltwentyseven.com">Channel Twenty Seven</a>'

    show2_link = show2.link
    show2_link.rel.should == 'alternate'
    show2_link.type.should == 'text/html'
    show2_link.href.should == 'http://www.example.com/sources/channel-twenty-seven/tv_shows/show-2.atom'
  end
  
end