atom_feed do |feed|
  feed.title("TV Shows")
  feed.updated(
    @tv_shows.first.try(:updated_at) ||
    Date.today
  )
 
  @tv_shows.each do |tv_show|
    next if tv_show.updated_at.blank?
    
    feed.entry(tv_show, :url => source_tv_show_url(tv_show.source, tv_show, :format => :atom)) do |entry|
      entry.content("#{tv_show.name} (#{tv_show.episodes.count} episodes)", :type => 'html')
      entry.title("[#{tv_show.source.name}] #{tv_show.name}")
      entry.author do |author|
        author.name("<a href=\"#{tv_show.source.url}\">#{tv_show.source.name}</a>", :type => 'html')
      end
    end
  end
end
