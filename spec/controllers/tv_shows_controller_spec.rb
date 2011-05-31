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
end