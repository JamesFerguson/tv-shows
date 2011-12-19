require 'spec_helper'

describe "each scraper" do
  include ScraperHelper

  before(:all) do
    FakeWeb.allow_net_connect = false
    seed_sources
    seed_tv_shows
  end

  after(:all) do
    Source.destroy_all
    TvShow.destroy_all
  end

  it "has a tv_show seeded" do
    Source.all.each do |source|
      source.tv_shows.count.should > 0
    end
  end


  # Shows
  it "scrapes 7 ok" do
    scrape_shows_index_spec(*Source.where(name: 'Yahoo Plus7').all)
  end

  it "scrapes 9 ok" do
    scrape_shows_index_spec(*Source.where(name: 'NineMSN Fixplay').all)
  end

  it "scrapes ABC1 ok" do
    scrape_shows_index_spec(*Source.where(name: 'ABC 1').all)
  end

  it "scrapes ABC2 ok" do
    scrape_shows_index_spec(*Source.where(name: 'ABC 2').all)
  end

  it "scrapes ABC3 ok" do
    scrape_shows_index_spec(*Source.where(name: 'ABC 3').all)
  end

  it "scrapes iView ok" do
    scrape_shows_index_spec(*Source.where(name: 'iView Originals').all)
  end

  it "scrapes SMH ok" do
    scrape_shows_index_spec(*Source.where(name: 'SMH.tv').all)
  end

  it "scrapes 10 ok" do
    scrape_shows_index_spec(*Source.where(name: 'Ten').all)
  end

  it "scrapes 1 ok" do
    scrape_shows_index_spec(*Source.where(name: 'OneHd').all)
  end

  it "scrapes 11 ok" do
    scrape_shows_index_spec(*Source.where(name: 'Eleven').all)
  end

  it "scrapes Neighbours ok" do
    scrape_shows_index_spec(*Source.where(name: 'Neighbours').all)
  end


  # Episodes
  it "scrapes 7 ok" do
    scrape_show_episodes(*Source.where(name: 'Yahoo Plus7').all)
  end

  it "scrapes 9 ok" do
    scrape_show_episodes(*Source.where(name: 'NineMSN Fixplay').all)
  end

  it "scrapes ABC1 ok" do
    scrape_show_episodes(*Source.where(name: 'ABC 1').all)
  end

  it "scrapes ABC2 ok" do
    scrape_show_episodes(*Source.where(name: 'ABC 2').all)
  end

  it "scrapes ABC3 ok" do
    scrape_show_episodes(*Source.where(name: 'ABC 3').all)
  end

  it "scrapes iView ok" do
    scrape_show_episodes(*Source.where(name: 'iView Originals').all)
  end

  it "scrapes SMH ok" do
    scrape_show_episodes(*Source.where(name: 'SMH.tv').all)
  end

  it "scrapes 10 ok" do
    scrape_show_episodes(*Source.where(name: 'Ten').all)
  end

  it "scrapes 1 ok" do
    scrape_show_episodes(*Source.where(name: 'OneHd').all)
  end

  it "scrapes 11 ok" do
    scrape_show_episodes(*Source.where(name: 'Eleven').all)
  end

  it "scrapes Neighbours ok" do
    scrape_show_episodes(*Source.where(name: 'Neighbours').all)
  end
end

