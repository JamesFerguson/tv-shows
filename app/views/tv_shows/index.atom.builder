atom_feed do |feed|
  feed.title("TV Shows")
  feed.updated(
    @tv_shows.first.try(:updated_at) ||
    Date.today
  )
 
  @tv_shows.each do |tv_show|
    next if tv_show.updated_at.blank?
    episodes = tv_show.episodes.active.order(:ordering)
    
    feed.entry(tv_show, :url => source_tv_show_url(tv_show.source, tv_show, :format => :atom)) do |entry|
      entry.title("[#{tv_show.source.name}] #{tv_show.name}")

      episode_lis = episodes.reduce('') do |items, episode|
        items += "    <li><a href=\"#{episode.url}\">#{episode.name}</a></li>\n"
      end.chomp
      tv_show_url = %w{AbcScraper TenScraper}.include? tv_show.source.scraper ? episodes.first.url : tv_show.url
      body = <<-HTML
<h1>#{tv_show.name} (#{episodes.count} episodes)</h1>
<p><strong>Subscribe</strong>: #{tv_show.name} <a href="#{source_tv_show_url(tv_show.source, tv_show, :format => :atom)}">episodes feed</a></p>
<p><strong>Homepage</strong>: <a href="#{tv_show_url}">#{tv_show.name} homepage</a></p>
<p><strong>Jump to an episode</strong>:
  <ul>
#{episode_lis}
  </ul>
</p>
      HTML
      entry.content(body, :type => 'html')
      entry.author do |author|
        author.name("<a href=\"#{tv_show.source.url}\">#{tv_show.source.name}</a>", :type => 'html')
      end
    end
  end
end
