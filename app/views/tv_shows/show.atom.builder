atom_feed do |feed|
  feed.title(@tv_show.name)
  feed.updated(@tv_show.episodes.first.updated_at)
  
  @tv_show.episodes.each do |episode|
    next if episode.updated_at.blank?
    
    feed.entry(episode, :url => episode.url) do |entry|
      entry.title(episode.name)
      entry.content("#{episode.name}", :type => 'html')
      entry.author do |author|
        author.name(@tv_show.source.url)
      end
    end
  end
end