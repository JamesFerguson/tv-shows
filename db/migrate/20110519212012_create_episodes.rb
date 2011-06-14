class CreateEpisodes < ActiveRecord::Migration
  def self.up
    create_table :episodes do |t|
      t.string :name
      t.string :url
      t.integer :season
      t.integer :number
      t.references :tv_show

      t.timestamps
    end
  end

  def self.down
    drop_table :episodes
  end
end
