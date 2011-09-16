class ChangeUrlToTextOnShow < ActiveRecord::Migration
  def self.up
    change_column :tv_shows, :url, :text
  end

  def self.down
    change_column :tv_shows, :url, :string
  end
end
