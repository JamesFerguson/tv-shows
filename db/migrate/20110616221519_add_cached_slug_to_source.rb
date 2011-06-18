class AddCachedSlugToSource < ActiveRecord::Migration
  def self.up
    add_column :sources, :cached_slug, :string
    add_index  :sources, :cached_slug, :unique => true
  end

  def self.down
    remove_column :sources, :cached_slug
  end
end
