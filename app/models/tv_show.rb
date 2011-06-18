class TvShow < ActiveRecord::Base
  belongs_to :source
  has_many :episodes, :dependent => :destroy

  has_friendly_id :name, :use_slug => true, :scope => :source

  scope :active, where(:deactivated_at => nil)
  
end
