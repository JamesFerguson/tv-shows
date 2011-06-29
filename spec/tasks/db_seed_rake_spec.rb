require 'spec_helper'
require 'rake'

describe "rake db:seed" do
  before do
    @rake = Rake.application
  end

  it "should create some sources" do
    @rake["db:seed"].invoke

    Source.count.should > 0
  end
end