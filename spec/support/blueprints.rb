require 'machinist/active_record'
require 'forgery'

Source.blueprint do
  name  { "Channel #{sn}" }
end

TvShow.blueprint do
  name  { Forgery::Name.full_name }
  data_url   { "http://#{object.name.parameterize}" }
end

Episode.blueprint do
  name      { "Episode #{sn}" }
  url       { "http://#{object.name.parameterize}" }
  ordering  { object.tv_show.episodes.count + 1 }
end
