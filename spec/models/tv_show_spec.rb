require 'spec_helper'

describe TvShow do
  context "slugs" do
    it "has a slug" do
      @tv_show = TvShow.make :name => "Winners And Losers"

      @tv_show.friendly_id.should == "winners-and-losers"
    end
    
    it "has a scoped slug" do
      @source_a = Source.make
      @source_b = Source.make
      
      @tv_show_a = @source_a.tv_shows.make :name => "Winners And Losers"
      @tv_show_b = @source_b.tv_shows.make :name => "Winners And Losers"

      @tv_show_a.friendly_id.should == "winners-and-losers"
      @tv_show_b.friendly_id.should == "winners-and-losers"
    end
  end
end