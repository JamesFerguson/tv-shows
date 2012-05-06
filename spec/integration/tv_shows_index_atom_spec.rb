require 'spec_helper'

describe "get :index, :format => :atom" do

  let(:source)      { Source.create!(name: "Channel Twenty Seven", url: "http://www.channeltwentyseven.com") }
  let(:show1)       { TvShow.create!(source: source, name: "Show 1", homepage_url: 'http://www.channeltwentyseven.com/show-1') }
  let(:episode1)   { Episode.create!(tv_show: show1, name: "Episode 1", url: 'http://www.channeltwentyseven.com/show-1/episode-1', ordering: 1) }
  let(:episode2)   { Episode.create!(tv_show: show1, name: "Episode 2", url: 'http://www.channeltwentyseven.com/show-1/episode-2', ordering: 0) }
  let(:show2)       { TvShow.create!(source: source, name: "Show 2", homepage_url: 'http://www.channeltwentyseven.com/show-2') }
  let(:episode15)  { Episode.create!(tv_show: show2, name: "Episode 15", url: 'http://www.channeltwentyseven.com/show-2/episode-15', ordering: 0) }
  let(:show3)      { TvShow.create!(source: source, name: "Show 3", homepage_url: 'http://www.channeltwentyseven.com/show-3') }
  let(:show4)      { TvShow.create!(source: source, name: "Show 4", homepage_url: 'http://www.channeltwentyseven.com/show-4', deactivated_at: Time.now) }

  before(:all) do
    Source.destroy_all # ???
    TvShow.destroy_all
    Episode.destroy_all

    # source
    # show1
    episode1
    episode2
    # show2
    episode15
    show3
    show4

    visit tv_shows_url(:format => :atom)
    @feed = AtomFeedMapping::Feed.parse(page.body)
  end

  it "has valid feed attributes" do
    @feed.id.should == "tag:www.example.com,2005:/tv_shows"
    @feed.title.should == 'TV Shows'
    @feed.updated.to_i.should >= show1.updated_at.to_i
  end

  it "has valid feed links" do
    alt_link = @feed.links.first
    alt_link.rel.should == 'alternate'
    alt_link.type.should == 'text/html'
    alt_link.href.should == 'http://www.example.com'

    self_link = @feed.links.last
    self_link.rel.should == 'self'
    self_link.type.should == 'application/atom+xml'
    self_link.href.should == 'http://www.example.com/tv_shows.atom'
  end

  it "has a feed stats entry" do
    stats_entry = @feed.entries[0]
    stats_entry.id.should == "tag:www.example.com,2005:Source/#{source.id}"
    stats_entry.title.should == '[AAA][AAA] Feed Stats'
    stats_entry.content.should == <<-HTML
<h1>Source show and episode counts:</h1>
<ul>
  <li>Channel Twenty Seven:
    <ul>
      <li>Shows
        <ul>
          <li>Active: 3</li>
          <li>Inactive: 1</li>
        </ul>
      </li>
      <li>Episodes
        <ul>
          <li>Active: 3</li>
          <li>Inactive: 0</li>
        </ul>
      </li>
    </ul>
  </li>
</ul>
    HTML

    stats_link = stats_entry.link
    stats_link.rel.should == 'alternate'
    stats_link.type.should == 'text/html'
    stats_link.href.should == 'http://www.example.com/'
  end

  it "has a valid entry for show 1" do
    entry1 = @feed.entries[1]
    entry1.id.should == "tag:www.example.com,2005:TvShow/#{show1.id}"
    entry1.title.should == '[Channel Twenty Seven] Show 1'
    entry1.content.should == <<-HTML
<h1>Show 1</h1>

<p style='float: left;'>2 episodes</p>
<p><strong>Subscribe</strong>: Show 1 <a href="http://www.example.com/sources/channel-twenty-seven/tv_shows/show-1.atom">episodes feed</a></p>
<p><strong>Homepage</strong>: <a href="http://www.channeltwentyseven.com/show-1">Show 1 homepage</a></p>
<p><strong>Jump to an episode</strong>:
  <ul>
    <li><a href="http://www.channeltwentyseven.com/show-1/episode-2\">Episode 2</a></li>
    <li><a href=\"http://www.channeltwentyseven.com/show-1/episode-1\">Episode 1</a></li>
  </ul>
</p>
    HTML
    entry1.author_name.should == '<a href="http://www.channeltwentyseven.com">Channel Twenty Seven</a>'

    entry1_link = entry1.link
    entry1_link.rel.should == 'alternate'
    entry1_link.type.should == 'text/html'
    entry1_link.href.should == 'http://www.example.com/sources/channel-twenty-seven/tv_shows/show-1.atom'
  end

  it "has a valid entry for show 2" do
    entry2 = @feed.entries[2]
    entry2.id.should == "tag:www.example.com,2005:TvShow/#{show2.id}"
    entry2.title.should == '[Channel Twenty Seven] Show 2'
    entry2.content.should == <<-HTML
<h1>Show 2</h1>

<p style='float: left;'>1 episodes</p>
<p><strong>Subscribe</strong>: Show 2 <a href=\"http://www.example.com/sources/channel-twenty-seven/tv_shows/show-2.atom\">episodes feed</a></p>
<p><strong>Homepage</strong>: <a href=\"http://www.channeltwentyseven.com/show-2\">Show 2 homepage</a></p>
<p><strong>Jump to an episode</strong>:
  <ul>
    <li><a href=\"http://www.channeltwentyseven.com/show-2/episode-15\">Episode 15</a></li>
  </ul>
</p>
    HTML
    entry2.author_name.should == '<a href="http://www.channeltwentyseven.com">Channel Twenty Seven</a>'

    entry2_link = entry2.link
    entry2_link.rel.should == 'alternate'
    entry2_link.type.should == 'text/html'
    entry2_link.href.should == 'http://www.example.com/sources/channel-twenty-seven/tv_shows/show-2.atom'
  end

  it "has a valid entry for show 3" do
    entry3 = @feed.entries[3]
    entry3.id.should == "tag:www.example.com,2005:TvShow/#{show3.id}"
  end

end
