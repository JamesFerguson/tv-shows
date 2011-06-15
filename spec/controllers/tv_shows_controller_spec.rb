require 'spec_helper'

describe TvShowsController do
  
  it "redirects rss to atom" do
    get :index, :format => :rss
    
    response.should be_redirect
    response.should redirect_to(:action => :index, :format => :atom)
  end

  it "renders a show index to atom" do
    @show = mock_model("TvShow")
    TvShow.stub(:all).and_return([@show])

    get :index, :format => "atom"

    assigns[:tv_shows].should == [@show]
    response.should render_template("show")
    response.content_type.should == 'application/atom+xml'
  end
  
  context "with inactive shows and episodes" do
    before(:each) do
      TvShow.destroy_all
      Episode.destroy_all
      
      @show_a = TvShow.make(:deactivated_at => DateTime.now - 3.hours)
      @ep_a1 = @show_a.episodes.make(:deactivated_at => DateTime.now - 3.hours)
      
      @show_b = TvShow.make
      @ep_b1 = @show_b.episodes.make
    end

    it "does not assign inactive shows in index" do
      get :index, :format => "atom"

      assigns[:tv_shows].should == [@show_b]
    end
    
    it "does not assign inactive episodes in show" do
      get :show, :id => @show_a, :format => "atom"

      assigns[:episodes].should == []

      # there's still a feed while a show is inactive.
      assigns[:tv_show].should == @show_a
    end
    
    it "does not assign inactive episodes anywhere else" do
      get :show, :id => @show_b, :format => "atom"

      assigns[:tv_show].should == @show_b
      assigns[:episodes].should == [@ep_b1]
    end
  end
end