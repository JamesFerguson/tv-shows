atom_feed do |feed|
  feed.title(@tv_show.name)
  feed.updated(@episodes.first.try(:updated_at))

  @episodes.order(:ordering).each do |episode|
    next if episode.updated_at.blank?

    image = episode.image.present? ? "<div style='float: right;'><img src='#{episode.image}' /></div>" : ''
    ep_body = <<-HTML
#{image}
<p><strong><a href="#{episode.url}">#{episode.name}</a></strong>#{episode.duration_desc}: #{episode.description}</p>
    HTML

    feed.entry(episode, :url => episode.url) do |entry|
      entry.title("#{episode.ordering.to_s.rjust(3, '0')} #{episode.name}")
      entry.content(ep_body, :type => 'html')
      entry.author do |author|
        author.name("<a href=\"#{@tv_show.source.url}\">#{@tv_show.source.name}</a>", :type => 'html')
      end
    end
  end
end
