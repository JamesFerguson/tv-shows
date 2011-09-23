class AddDataUrlToTvShows < ActiveRecord::Migration
  def self.up
    rename_column :tv_shows, :url, :data_url
    add_column :tv_shows, :homepage_url, :string
  end

  def self.down
    remove_column :tv_shows, :homepage_url
    rename_column :tv_shows, :data_url, :url
  end
end
