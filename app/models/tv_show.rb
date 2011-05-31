class TvShow < ActiveRecord::Base
  belongs_to :source
  has_many :episodes
end
