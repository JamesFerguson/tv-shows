class Episode < ActiveRecord::Base
  belongs_to :tv_show

  scope :active, where(:deactivated_at => nil)
  
end
