module TenXmlParser
  # class Tag
  #   include HappyMapper
  #   tag "tag"

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
    element :image, String, :xpath => './defaultImage/url'
    element :duration, String
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
    element :external_links, String, :single => false, :xpath => "./childPlaylists/playlist/tags/tag[ns='external' and predicate='link']/value"
    element :genre, String, :xpath => "./mediaList/media[1]/tags/tag[predicate='genre']/value"
    element :image, String, :xpath => './defaultImage/url'

    has_one :media_list, MediaList, :xpath => '.'
    has_one :child_playlists, ChildPlaylist, :xpath => '.'
    # has_many :tags, Tag, :xpath => 'mediaList/media[1]/tags'
  end

  class ChildPlaylist
    include HappyMapper
    tag 'childPlaylists'

    has_many :playlists, Playlist
  end
end
