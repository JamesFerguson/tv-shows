require 'spec_helper'

describe Source do
  it "#cleanup" do
    source = Source.make
    source.tv_shows << TvShow.make(:name => "Number 1")
    source.tv_shows << TvShow.make
    source.tv_shows.last.update_attributes!(:updated_at => DateTime.now - 3.hours)

    source.cleanup(source.tv_shows)

    source.tv_shows.count.should == 1
    source.tv_shows.first.name.should == "Number 1"
  end
end