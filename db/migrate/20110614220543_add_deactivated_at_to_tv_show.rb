class AddDeactivatedAtToTvShow < ActiveRecord::Migration
  def self.up
    add_column :tv_shows, :deactivated_at, :datetime
  end

  def self.down
    remove_column :tv_shows, :deactivated_at
  end
end
