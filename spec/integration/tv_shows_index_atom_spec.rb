require 'spec_helper'

describe "get :index, :format => :atom" do
  
  before do
    visit tv_shows_url(:format => :atom)
  end
  
  it 'has a sign out link' do
    # puts page.has_xpath('//feed')
    # page.driver.html.xpath('//id').text
    #page.all('//feed').first.text
    debugger
    page.should have_xpath('//feed') # , :text => 'Sign Out'
  end
  
end