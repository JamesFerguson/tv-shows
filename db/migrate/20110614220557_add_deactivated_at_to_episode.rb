class AddDeactivatedAtToEpisode < ActiveRecord::Migration
  def self.up
    add_column :episodes, :deactivated_at, :datetime
  end

  def self.down
    remove_column :episodes, :deactivated_at
  end
end
