module TenXmlParser
  # class Tag
  #   include HappyMapper
  #   tag "tag[ns='external' and predicate='link']"

  #   element :ns, String
  #   element :predicate, String
  #   element :value, String
  # end

  class Media
    include HappyMapper
    tag 'media'

    element :title, String
    element :id, Integer
    element :description, String
  end

  class MediaList
    include HappyMapper
    tag 'mediaList'

    has_many :media, Media
  end

  # forward declaration to work around circular dependency
  class ChildPlaylist

  end

  class Playlist
    include HappyMapper
    tag 'playlist'

    element :title, String
    element :id, Integer
    element :external_links, String, :single => false, :deep => true, :tag => 'value', :xpath => "//playlist/tags/tag[ns='external' and predicate='link']/value"

    has_one :media_list, MediaList, :xpath => '.'
    has_one :child_playlists, ChildPlaylist, :xpath => '.'
    # has_many :tags, Tag, :xpath => './tags'
  end

  class ChildPlaylist
    include HappyMapper
    tag 'childPlaylists'

    has_many :playlists, Playlist
  end
end
