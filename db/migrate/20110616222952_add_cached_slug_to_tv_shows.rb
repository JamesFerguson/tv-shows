class AddCachedSlugToTvShows < ActiveRecord::Migration
  def self.up
    add_column :tv_shows, :cached_slug, :string
    add_index  :tv_shows, [:source_id, :cached_slug], :unique => true
  end

  def self.down
    remove_column :tv_shows, :cached_slug
  end
end
