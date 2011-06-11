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
  }
]

sources.each do |source_data|
  Source.find_or_create(Source, :name, source_data)
end