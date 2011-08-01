atom_feed do |feed|
  feed.title(@tv_show.name)
  feed.updated(@episodes.first.try(:updated_at))
  
  @episodes.order(:ordering).each do |episode|
    next if episode.updated_at.blank?
    
    feed.entry(episode, :url => episode.url) do |entry|
      entry.title("#{episode.ordering.to_s.rjust(3, '0')} #{episode.name}")
      entry.content("#{episode.name}", :type => 'html')
      entry.author do |author|
        author.name(@tv_show.source.url)
      end
    end
  end
end
