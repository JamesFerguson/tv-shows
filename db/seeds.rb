# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

sources = [
  {
    :name => "Channel Seven",
    :url => 'http://au.tv.yahoo.com/plus7/browse/',
    :scraper => "SevenScraper"
  },
  {
    :name => "Channel Nine",
    :url => 'http://fixplay.ninemsn.com.au/catalogue',
    :scraper => "NineScraper"
  },
  {
    :name => "ABC 1",
    :url => "http://tviview.abc.net.au/iview/rss/category/abc1.xml",
    :scraper => "AbcScraper"
  },
  {
    :name => "ABC 2",
    :url => "http://tviview.abc.net.au/iview/rss/category/abc2.xml",
    :scraper => "AbcScraper"
  },
  {
    :name => "ABC 3",
    :url => "http://tviview.abc.net.au/iview/rss/category/abc3.xml",
    :scraper => "AbcScraper"
  },
  {
    :name => "iView Originals",
    :url => "http://tviview.abc.net.au/iview/rss/category/original.xml",
    :scraper => "AbcScraper"
  },
  {
    :name => "SMH.tv",
    :url => "http://www.smh.com.au/tv/type/show", # ??
    :scraper => "SmhScraper"
  }
]

sources.each do |source_data|
  Source.find_or_create(Source, :name, source_data)
end

if %w{development test}.include? Rails.env
  def seed_tv_shows
    Source.where(:name => "Channel Nine").first.tv_shows.make(:name => "AFP", :url => "http://fixplay.ninemsn.com.au/afp")

    Source.where(:name => "Channel Seven").first.tv_shows.make(
      :name => "Winners and Losers",
      :url => "http://au.tv.yahoo.com/plus7/winners-and-losers/"
    )

    Source.where(:name => "SMH.tv").first.tv_shows.make(
      :name => "Baby Baby",
      :url => "http://www.smh.com.au/tv/show/baby-baby-20110308-1bm6s.html"
    )
  end
end