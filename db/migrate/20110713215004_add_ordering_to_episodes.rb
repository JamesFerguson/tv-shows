class AddOrderingToEpisodes < ActiveRecord::Migration
  def self.up
    add_column :episodes, :ordering, :integer
    add_index :episodes, [:tv_show_id, :ordering], :unique => true
  end

  def self.down
    remove_column :episodes, :ordering
  end
end
