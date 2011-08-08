# require 'happymapper'

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
end
