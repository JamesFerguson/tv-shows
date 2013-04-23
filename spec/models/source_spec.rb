require 'spec_helper'

describe Source do
  context "scrape" do
    before(:each) do
      @source = Source.make!(scraper: "NineScraper")
      @source.tv_shows.destroy_all
    end

    it "adds new shows and their episodes when found in the feed" do
      @source.scraper_class.stub(:extract_shows).
        and_return([{name: "A", data_url: "http://A"}])
      @source.scraper_class.stub(:extract_episodes).
        and_return([{name: "A1", url: "http://A1", ordering: 0}])

      @source.scrape

      @source.tv_shows.active.first.data_url.should == "http://A"
      @source.tv_shows.active.count == 1
      @source.tv_shows.active.first.episodes.active.first.url.should == "http://A1"
      @source.tv_shows.active.first.episodes.active.count == 1
    end

    it "reups existing shows and their episodes when found in the feed" do
      @show = @source.tv_shows.make! name: "A", data_url: "http://A"
      @show.episodes.make! name: "A1", url: "http://A1"

      @source.scraper_class.stub(:extract_shows).
        and_return([{name: "A", data_url: "http://A"}])
      @source.scraper_class.stub(:extract_episodes).
        and_return([{name: "A1", url: "http://A1", ordering: 0}])

      @source.scrape

      @source.tv_shows.first.data_url.should == "http://A"
      @source.tv_shows.active.first.data_url.should == "http://A"
      @source.tv_shows.active.count == 1
      @source.tv_shows.active.first.episodes.first.url.should == "http://A1"
      @source.tv_shows.active.first.episodes.active.first.url.should == "http://A1"
      @source.tv_shows.active.first.episodes.active.count == 1
    end

    it "deactivates shows/episodes not in the feed" do
      @b = @source.tv_shows.make!
      @b1 = @b.episodes.make!
      @source.scraper_class.stub(:extract_shows).and_return([])

      @source.scrape

      @source.tv_shows.active.where(id: @b.id).first.should be_nil
      @source.tv_shows.where(id: @b.id).count.should == 1
      Episode.active.first.should be_nil
    end

    it "removes shows/episodes not in the feed and of a certain age" do
      @b = @source.tv_shows.make!
      @b.update_attributes!(deactivated_at: DateTime.now - 6.months - 1.day)
      @b1 = @b.episodes.make!
      @b1.update_attributes!(deactivated_at: DateTime.now - 6.months - 1.day)
      @source.scraper_class.stub(:extract_shows).and_return([])

      @source.scrape

      @source.tv_shows.where(id: @b.id).first.should be_nil
      Episode.all.first.should be_nil
    end
  end

  context "slugs" do
    it "has a slug" do
      @source = Source.make! name: "Channel 9"

      @source.friendly_id.should == "channel-9"
    end
  end

  context "Source.find_or_create" do
    before do
      Source.find_or_create(Source, :name, name: "Channel Z", url: "http://abc")

      Source.where(name: "Channel Z", url: "http://abc").count.should == 1
    end

    it "first create" do
      Source.where(name: "Channel Z", url: "http://abc").count.should == 1
    end

    it "second create of same object" do
      Source.find_or_create(Source, :name, name: "Channel Z", url: "http://abc")

      Source.where(name: "Channel Z", url: "http://abc").count.should == 1
    end

    it "second create of object with diff url" do
      Source.find_or_create(Source, :name, name: "Channel Z", url: "http://def")

      Source.where(name: "Channel Z", url: "http://abc").count.should == 0
      Source.where(name: "Channel Z", url: "http://def").count.should == 1
    end
  end

  it "#cleanup" do
    source = Source.make!
    source.tv_shows << TvShow.make!(name: "Number 1")
    source.tv_shows << TvShow.make!
    source.tv_shows.last.update_attributes!(deactivated_at: DateTime.now - 3.hours)
    source.tv_shows << TvShow.make!
    source.tv_shows.last.update_attributes!(deactivated_at: DateTime.now - 1.month - 1.day)

    source.send(:cleanup, source.tv_shows, DateTime.now - 1.month)

    source.tv_shows.count.should == 2
    source.tv_shows.active.count.should == 1
    source.tv_shows.active.last.name.should == "Number 1"

    source.send(:cleanup, source.tv_shows, DateTime.now - 2.hours)

    source.tv_shows.count.should == 1
    source.tv_shows.active.count.should == 1
    source.tv_shows.active.last.name.should == "Number 1"
  end
end
