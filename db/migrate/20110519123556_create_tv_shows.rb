class CreateTvShows < ActiveRecord::Migration
  def self.up
    create_table :tv_shows do |t|
      t.string :name
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :tv_shows
  end
end
