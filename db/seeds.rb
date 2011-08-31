# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

sources = [
  {
    :name => "Yahoo Plus7",
    :url => 'http://au.tv.yahoo.com/plus7/browse/',
    :scraper => "SevenScraper"
  },
  {
    :name => "NineMSN Fixplay",
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
    :url => "http://www.smh.com.au/tv/type/show",
    :scraper => "SmhScraper"
  },
  {
    :name => "Ten",
    :url => "http://ten.com.au/api/rest/session?key=movideoNetwork10&applicationalias=main-player",
    :scraper => "TenScraper"
  },
  {
    :name => "OneHd",
    :url => "http://api.v2.movideo.com/rest/session?key=movideoOneHd&applicationalias=onehd-cutv-universal-flash",
    :scraper => "TenScraper"
  },
  {
    :name => "Eleven",
    :url => "http://api.movideo.com/rest/session?key=movideoEleven&applicationalias=eleven-twix-flash&includeApplication=true",
    :scraper => "TenScraper"
  },
  {
    :name => "Neighbours",
    :url => "http://api.movideo.com/rest/session?key=movideoNeighbours&applicationalias=neighbours-universal-flash",
    :scraper => "TenScraper"
  }
]

# Additional ten satellite sites: 
# Neighbours, http://api.movideo.com/rest/session?key=movideoNeighbours&applicationalias=neighbours-universal-flash 41267 http://neighbours.com.au/video.htm?movideo_p=41267
# Stargate, http://api.v2.movideo.com/rest/session?key=movideoEleven&applicationalias=eleven-stargate 43967 
# Masterchef, http://api.v2.movideo.com/rest/session?key=movideoMasterChef&applicationalias=masterchef-2011 40328 http://www.masterchef.com.au/video.htm?movideo_m=122688&movideo_p=44688
# 7PM Project, http://api.v2.movideo.com/rest/session?key=movideo7pmProject&applicationalias=7pmproject-universal-flash 39688 http://7pmproject.com.au/video.htm
# Ready Steady Cook, http://api.v2.movideo.com/rest/session?key=movideo10&applicationalias=ready-steady-cook 38735 http://readysteadycook.ten.com.au/video.htm
# The Biggest Loser, 
# The Circle, 
# The Renovators http://api.v2.movideo.com/rest/session\?key\=movideoRenovators\&applicationalias\=renovators-universal-flash 44821 http://therenovatorstv.com.au/video.htm?

sources.each do |source_data|
  Source.find_or_create(Source, :name, source_data)
end
