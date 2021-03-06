# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110922215119) do

  create_table "episodes", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "season"
    t.integer  "number"
    t.integer  "tv_show_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deactivated_at"
    t.integer  "ordering"
    t.text     "description"
    t.integer  "duration"
    t.text     "image"
  end

  add_index "episodes", ["tv_show_id", "ordering"], :name => "index_episodes_on_tv_show_id_and_ordering", :unique => true

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "sources", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "scraper"
    t.string   "cached_slug"
  end

  add_index "sources", ["cached_slug"], :name => "index_sources_on_cached_slug", :unique => true

  create_table "tv_shows", :force => true do |t|
    t.string   "name"
    t.text     "data_url"
    t.integer  "source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deactivated_at"
    t.string   "cached_slug"
    t.text     "description"
    t.text     "image"
    t.string   "classification"
    t.string   "genre"
    t.string   "homepage_url"
  end

  add_index "tv_shows", ["source_id", "cached_slug"], :name => "index_tv_shows_on_source_id_and_cached_slug", :unique => true

end
