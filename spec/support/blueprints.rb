require 'machinist/active_record'
require 'sham'
require 'forgery'

Sham.name { Forgery::Name.full_name }

Sham.source_name { |index| "Channel #{index}" }
Source.blueprint do
  name  { Sham.source_name }
end

TvShow.blueprint do
  name  { Sham.name }
end

Sham.episode_name { |index| "Episode #{index}" }
Episode.blueprint do
  name  { Sham.episode_name }
end