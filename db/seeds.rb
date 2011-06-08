# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Source.delete_all
TvShow.delete_all
Episode.delete_all

require 'scrapers/seven_scraper'

@source = Source.create(
  :name => "Seven.com.au",
  :url => 'http://au.tv.yahoo.com/plus7/browse/'
)
SevenScraper.extract_shows.each { |show_data| @source.tv_shows.create!(show_data) }
@source.save!
@source.tv_shows.each do |show|
  SevenScraper.extract_show(show).each { |ep_data| show.episodes.create!(ep_data) }
  show.save!
end