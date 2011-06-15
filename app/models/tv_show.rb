class TvShow < ActiveRecord::Base
  belongs_to :source
  has_many :episodes, :dependent => :destroy

  scope :active, where(:deactivated_at => nil)
  
end
