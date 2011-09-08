module TenXmlParser
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

    has_one :media_list, MediaList, :xpath => '.'
    has_one :child_playlists, ChildPlaylist, :xpath => '.'
  end

  class ChildPlaylist
    include HappyMapper
    tag 'childPlaylists'

    has_many :playlists, Playlist
  end
end
