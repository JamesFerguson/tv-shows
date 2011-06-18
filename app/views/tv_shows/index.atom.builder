atom_feed do |feed|
  feed.title("TV Shows")
  feed.updated(
    @tv_shows.first.try(:updated_at) ||
    Date.today
  )
 
  @tv_shows.each do |tv_show|
    next if tv_show.updated_at.blank?
    
    feed.entry(tv_show, :url => source_tv_show_url(tv_show.source, tv_show, :format => :atom)) do |entry|
      entry.title(tv_show.name)
      entry.content("#{tv_show.name} (#{tv_show.episodes.count} episodes)", :type => 'html')
      entry.author do |author|
        author.name(tv_show.source.url)
      end
    end
  end
end
