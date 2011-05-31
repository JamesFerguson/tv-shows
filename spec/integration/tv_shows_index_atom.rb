require 'spec_helper'

describe "get :index, :format => :atom" do
  
  before do
    visit tv_shows_url(:format => :atom)
  end
  
  it 'has a sign out link' do
    page.should have_xpath('//a', :text => 'Sign Out')
  end
  
end