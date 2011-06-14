require 'spec_helper'
require 'rake'

describe "rake db:seed" do
  before do
    rake = Rake.application
    rake.init
    rake.load_rakefile
    rake["db:seed"].invoke
  end
  
  it "should create some sources" do
    Source.count.should > 0
  end
end