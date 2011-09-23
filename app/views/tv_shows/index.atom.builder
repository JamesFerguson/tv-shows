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
      genre_header = tv_show.genre.present? ? "[#{tv_show.genre}]" : ''
      entry.title("#{genre_header}[#{tv_show.source.name}] #{tv_show.name}")

      image = tv_show.image.present? ? "<div style='float: right;'><img src='#{tv_show.image}' /></div>" : ''
      description = tv_show.description.present? ? ": #{tv_show.description}" : ''
      genre = tv_show.genre.present? ? "#{tv_show.genre}, " : ''
      classification = tv_show.classification.present? ? " (#{tv_show.classification})" : ''
      episode_lis = episodes.reduce('') do |items, episode|
        items += "    <li><a href=\"#{episode.url}\">#{episode.name}</a></li>\n"
      end.chomp
      body = <<-HTML
<h1>#{tv_show.name}</h1>
#{image}
<p>#{genre}#{episodes.count} episodes#{description}#{classification}</p>
<p><strong>Subscribe</strong>: #{tv_show.name} <a href="#{source_tv_show_url(tv_show.source, tv_show, :format => :atom)}">episodes feed</a></p>
<p><strong>Homepage</strong>: <a href="#{tv_show.homepage_url}">#{tv_show.name} homepage</a></p>
<p><strong>Jump to an episode</strong>:
  <ul>
#{episode_lis}
  </ul>
</p>
#{classification}
      HTML
      entry.content(body, :type => 'html')
      entry.author do |author|
        author.name("<a href=\"#{tv_show.source.url}\">#{tv_show.source.name}</a>", :type => 'html')
      end
    end
  end
end
