class AddParserToSources < ActiveRecord::Migration
  def self.up
    add_column :sources, :parser, :string
  end

  def self.down
    remove_column :sources, :parser
  end
end
