class AddDescriptionToEpisodes < ActiveRecord::Migration
  def self.up
    add_column :episodes, :description, :text
    add_column :episodes, :duration, :integer
    add_column :episodes, :image, :text
  end

  def self.down
    remove_column :episodes, :image
    remove_column :episodes, :duration
    remove_column :episodes, :description
  end
end
