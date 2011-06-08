class AddScraperToSources < ActiveRecord::Migration
  def self.up
    add_column :sources, :scraper, :string
  end

  def self.down
    remove_column :sources, :scraper
  end
end
