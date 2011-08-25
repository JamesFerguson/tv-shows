module TenXmlParser
  class Playlist
    include HappyMapper
    tag 'playlist'

    element :title, String
    element :id, Integer
  end

  class ChildPlaylist
    include HappyMapper
    tag 'childPlaylists'

    has_many :playlists, Playlist
  end

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
end
