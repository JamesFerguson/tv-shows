module AtomFeedMapping
  class Link
    include HappyMapper
    tag 'link'

    attribute :rel, String
    attribute :type, String
    attribute :href, String
  end

  class Entry
    include HappyMapper
    tag 'entry'

    element :id, String, :single => true
    element :published, DateTime, :single => true
    element :updated, DateTime, :single => true
    element :title, String, :single => true
    element :content, String, :single => true
    element :author_name, String, :single => true, :tag => 'name', :deep => true
    has_one :link, Link, :deep => false
  end

  class Feed
    include HappyMapper
    tag 'feed'

    attribute :xmlns, String, :single => true

    element :id, String, :single => true
    element :title, String, :single => true
    element :updated, DateTime, :single => true

    has_many :links, Link, :tag => 'link', :xpath => '.'
    has_many :entries, Entry
  end
end

