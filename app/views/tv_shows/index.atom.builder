atom_feed do |feed|
  feed.title("TV Shows")
  feed.updated(
    @tv_shows.active.first.try(:updated_at) ||
    Date.today
  )

  feed.entry(Source.first, url: root_url) do |entry|
    entry.title('[AAA][AAA] Feed Stats')

    stats = Source.all.map do |source|
        stat = <<-HTML
  <li>#{source.name}:
    <ul>
      <li>Shows
        <ul>
          <li>Active: #{source.tv_shows.active.count}</li>
          <li>Inactive: #{source.tv_shows.inactive.count}</li>
        </ul>
      </li>
      <li>Episodes
        <ul>
          <li>Active: #{source.tv_shows.joins(:episodes).where("episodes.deactivated_at IS NULL").count}</li>
          <li>Inactive: #{source.tv_shows.joins(:episodes).where("episodes.deactivated_at IS NOT NULL").count}</li>
        </ul>
      </li>
    </ul>
  </li>
        HTML
      end.join("\n")

    body = <<-HTML
<h1>Source show and episode counts:</h1>
<ul>
#{stats}</ul>
    HTML

    entry.content(body, type: 'html')
  end

  @tv_shows.active.each do |tv_show|
    episodes = tv_show.episodes.active.order(:ordering)

    feed.entry(tv_show, :url => source_tv_show_url(tv_show.source, tv_show, :format => :atom)) do |entry|
      genre_header = tv_show.genre.present? ? "[#{tv_show.genre}]" : ''
      entry.title("#{genre_header}[#{tv_show.source.name}] #{tv_show.name}")

      image = tv_show.image.present? ? "<div style='float: right;'><img src='#{tv_show.image}' /></div>" : ''
      description = tv_show.description.present? ? ": #{tv_show.description}" : ''
      genre = tv_show.genre.present? ? "#{tv_show.genre}, " : ''
      classification = tv_show.classification.present? ? " (#{tv_show.classification})" : ''
      episode_lis = episodes.reduce('') do |items, episode|
        ep_desc = episode.description.present? ? ": #{episode.description}" : ''

        items += "    <li><a href=\"#{episode.url}\">#{episode.name}</a>#{episode.duration_desc}#{ep_desc}</li>\n"
      end.chomp
      body = <<-HTML
<h1>#{tv_show.name}</h1>
#{image}
<p style='float: left;'>#{genre}#{episodes.count} episodes#{description}#{classification}</p>
<p><strong>Subscribe</strong>: #{tv_show.name} <a href="#{source_tv_show_url(tv_show.source, tv_show, :format => :atom)}">episodes feed</a></p>
<p><strong>Homepage</strong>: <a href="#{tv_show.homepage_url}">#{tv_show.name} homepage</a></p>
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
