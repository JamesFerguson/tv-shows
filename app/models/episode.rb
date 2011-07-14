class Episode < ActiveRecord::Base
  belongs_to :tv_show

  validates_presence_of :ordering
  validates_uniqueness_of :ordering, :scope => :tv_show_id

  scope :active, where(:deactivated_at => nil)
  
end
