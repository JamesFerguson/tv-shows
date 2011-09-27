class Episode < ActiveRecord::Base
  belongs_to :tv_show

  validates_presence_of :ordering, :if => :active?
  validates_uniqueness_of :ordering, :scope => :tv_show_id, :if => :active?

  scope :active, where(:deactivated_at => nil)

  def active?
    !deactivated_at
  end

  def duration_desc
    duration.present? ? " (#{(duration / 60.0).ceil} mins)" : ''
  end
end
