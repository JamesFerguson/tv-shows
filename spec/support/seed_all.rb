def seed_tv_shows
  tv_shows = [
    {
      :source => "NineMSN Fixplay",
      :name => "AFP",
      :url => "http://fixplay.ninemsn.com.au/afp"
    },
    {
      :source => "Yahoo Plus7",
      :name => "Jeeves and Wooster",
      :url => "http://au.tv.yahoo.com/plus7/jeeves-and-wooster/"
    },
    {
      :source => "ABC 1",
      :name => "Angry Boys",
      :url => "http://www.abc.net.au/reslib/201105/r763726_6441373.jpg"
    },
    {
      :source => "ABC 2",
      :name => "The Catherine Tate Show",
      :url => "http://www.abc.net.au/reslib/201007/r600879_3911401.jpg"
    },
    {
      :source => "ABC 3",
      :name => "Pat And Stan",
      :url => "http://www.abc.net.au/reslib/200907/r392871_1838133.jpg"
    },
    {
      :source => "iView Originals",
      :name => "Doctor Who: Adventures In The Human Race ",
      :url => "http://www.abc.net.au/reslib/201105/r776210_6644927.jpg"
    },
    {
      :source => "SMH.tv",
      :name => "Baby Baby",
      :url => "http://www.smh.com.au/tv/show/baby-baby-20110308-1bm6s.html"
    },
    {
      :source => "Ten",
      :name => "Totally Wild",
      :url => "http://api.v2.movideo.com/rest/playlist/41457?depth=1&token=23789ee7-a6ee-48f0-9931-4fa85965baf3&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate"
    },
    {
      :source => "OneHd",
      :name => "America's Port",
      :url => "http://api.v2.movideo.com/rest/playlist/45405?depth=1&token=1d43e9b0-1352-4b34-9c65-2cc57c112171&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate,isAdvertisement,defaultImage,imagePath"
    },
    {
      :source => "Eleven",
      :name => "Being Human | Full Episodes",
      :url => "http://api.v2.movideo.com/rest/playlist/45050?depth=1&token=5c8d7056-1d4e-44de-967d-13731df0d3d8&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate,isAdvertisement,defaultImage,imagePath"
    },
    {
      :source => "Neighbours",
      :name => "Neighbours",
      :url => "http://api.v2.movideo.com/rest/playlist/41267?depth=1&token=5c8d7056-1d4e-44de-967d-13731df0d3d8&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate,isAdvertisement,defaultImage,imagePath"
    }
  ]

  tv_shows.each do |show_data|
    source_name = show_data.delete(:source)

    collection = Source.where(:name => source_name).first.tv_shows

    Source.find_or_create(collection, :url, show_data)
  end
end

def seed_sources
  load Rails.root.join('db/seeds.rb')
end

SEEDED_SHOW_ATTRS = {
  "Jeeves and Wooster" => {
    "name"=>"Jeeves and Wooster",
    "description" => "Comedy drama series following the insane shenanigans of Bertram Wooster (Hugh Laurie) and his faithful butler Jeeves (Stephen Fry). Each episode sees Wooster unwittingly caught up in some kind of scrape, and each time it's down to his trusty aide Jeeves to come up with a cunning masterplan to get him off the hook.", 
    "classification" => "PG", 
    "genre" => "Comedy", 
    "image" => "http://l.yimg.com/ao/i/tv/portal/promos/autv-plus7-jeeves-and-wooster.jpg"
  },
  "AFP" => {
    "name" => "AFP",
    "description" => "More than 6500 men and women - across thirty countries and in forty cities - on guard against crime in Australia and around the world. \nAFP will take you behind the scenes with the men and women of the Australian Federal Police. Never before has an Australian audience been given such unprecedented access to the work of Australia's national and international policing agency. \n\n",
    "classification" => nil,
    "genre" => "Reality",
    "image" => "http://fixplay.ninemsn.com.au/img/all_Show_section/afp.jpg"
  }
}
