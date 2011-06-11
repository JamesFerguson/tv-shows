require 'spec_helper'

describe Source do
  context "scrape" do
    before(:each) do
      @source = Source.make(:scraper => "NineScraper")
      @source.tv_shows.destroy_all
    end
    
    it "adds new shows and their episodes when found in the feed" do
      @source.scraper_class.stub(:extract_shows).
        and_return([{:name => "A", :url => "http://A"}])
      @source.scraper_class.stub(:extract_episodes).
        and_return([{:name => "A1", :url => "http://A1"}])

      @source.scrape

      @source.tv_shows.first.url.should == "http://A"
      @source.tv_shows.count == 1
      @source.tv_shows.first.episodes.first.url.should == "http://A1"
      @source.tv_shows.first.episodes.count == 1
    end

    it "removes shows (and their episodes) if they're no longer in the feed" do
      @b = @source.tv_shows.make
      @b.update_attributes!(:updated_at => DateTime.now - 3.hours)
      @b1 = @b.episodes.make
      @b1.update_attributes!(:updated_at => DateTime.now - 3.hours)
      @source.scraper_class.stub(:extract_shows).
        and_return([])

      @source.scrape

      @source.tv_shows.where(:id => @b.id).first.should be_nil
      Episode.all.first.should be_nil
    end
    
    # before(:each) do
    #   show_hashes = {}
    #   %w{A B C}.each do |show|
    #     show_hashes[show.to_sym] = { :name => show, :url => "http://" + show }
    #   end
    #   @source = Source.last
    #   @a = @source.tv_shows.make(show_hashes[:A])
    #   @a1 = @a.episodes.make(:url => "http://a1")
    #   @b = @source.tv_shows.make(show_hashes[:B])
    #   @b1 = @b.episodes.make(:url => "http://b1")
    #   @b2 = @b.episodes.make(:url => "http://b2")
    # end
    # 
    # it "works!" do
    #   @source.scraper_class.stub(:extract_shows).
    #     and_return([show_hashes[:B], show_hashes[:C]])
    #   @source.scraper_class.stub(:extract_shows).with(@b)
    #     and_return()
    # end
    # create an old tv show, A with an episode A1
    # create a tv show, B, with an old episode, B1, and an episode B2
    # stub extract_shows to return B and C
    # stub extract_episodes(B) to return B2
    # stub extract_episodes(C) to return C1
    
    # source.scrape
    
    # A should not exist
    # A1 should not exist
    # B1 should not exist
    # B & C should exist
    # B2 & C1 should exist
  end
  
  context "Source.find_or_create" do
    before do
      Source.find_or_create(Source, :name, :name => "Channel Z", :url => "http://abc")

      Source.where(:name => "Channel Z", :url => "http://abc").count.should == 1
    end

    it "first create" do
      Source.where(:name => "Channel Z", :url => "http://abc").count.should == 1
    end

    it "second create of same object" do
      Source.find_or_create(Source, :name, :name => "Channel Z", :url => "http://abc")

      Source.where(:name => "Channel Z", :url => "http://abc").count.should == 1
    end

    it "second create of object with diff url" do
      Source.find_or_create(Source, :name, :name => "Channel Z", :url => "http://def")

      Source.where(:name => "Channel Z", :url => "http://abc").count.should == 0
      Source.where(:name => "Channel Z", :url => "http://def").count.should == 1
    end
  end

  it "#cleanup" do
    source = Source.make
    source.tv_shows << TvShow.make(:name => "Number 1")
    source.tv_shows << TvShow.make
    source.tv_shows.last.update_attributes!(:updated_at => DateTime.now - 3.hours)

    source.send(:cleanup, source.tv_shows)

    source.tv_shows.count.should == 1
    source.tv_shows.first.name.should == "Number 1"
  end
end