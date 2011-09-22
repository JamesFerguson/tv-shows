class AddDescriptionToTvShows < ActiveRecord::Migration
  def self.up
    add_column :tv_shows, :description, :text
    add_column :tv_shows, :image, :text
    add_column :tv_shows, :classification, :string
    add_column :tv_shows, :genre, :string
  end

  def self.down
    remove_column :tv_shows, :genre
    remove_column :tv_shows, :classification
    remove_column :tv_shows, :image
    remove_column :tv_shows, :description
  end
end
