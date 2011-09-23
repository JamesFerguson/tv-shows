def seed_tv_shows
  tv_shows = [
    {
      :source => "NineMSN Fixplay",
      :name => "AFP",
      :data_url => "http://fixplay.ninemsn.com.au/afp"
    },
    {
      :source => "Yahoo Plus7",
      :name => "Jeeves and Wooster",
      :data_url => "http://au.tv.yahoo.com/plus7/jeeves-and-wooster/"
    },
    {
      :source => "ABC 1",
      :name => "Angry Boys",
      :data_url => "http://www.abc.net.au/iview/#/view/784101",
      :image => "http://www.abc.net.au/reslib/201105/r763726_6441373.jpg",
      :genre => "Comedy"
    },
    {
      :source => "ABC 2",
      :name => "The Catherine Tate Show",
      :data_url => "http://www.abc.net.au/iview/#/view/659856",
      :image => "http://www.abc.net.au/reslib/201007/r600879_3911401.jpg",
      :genre => "Comedy"
    },
    {
      :source => "ABC 3",
      :name => "Pat And Stan",
      :data_url => "http://www.abc.net.au/iview/#/view/788445",
      :image => "http://www.abc.net.au/reslib/200907/r392871_1838133.jpg",
      :genre => "Abc3"
    },
    {
      :source => "iView Originals",
      :name => "Doctor Who: Adventures In The Human Race ",
      :data_url => "http://www.abc.net.au/iview/#/view/784107",
      :image => "http://www.abc.net.au/reslib/201105/r776210_6644927.jpg",
      :genre => "Drama"
    },
    {
      :source => "SMH.tv",
      :name => "Baby Baby",
      :data_url => "http://www.smh.com.au/tv/show/baby-baby-20110308-1bm6s.html"
    },
    {
      :source => "Ten",
      :name => "Totally Wild",
      :data_url => "http://api.v2.movideo.com/rest/playlist/41457?depth=1&token=23789ee7-a6ee-48f0-9931-4fa85965baf3&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate,isAdvertisement,imagePath",
      :genre => "Children's TV"
    },
    {
      :source => "OneHd",
      :name => "America's Port",
      :data_url => "http://api.v2.movideo.com/rest/playlist/45405?depth=1&token=1d43e9b0-1352-4b34-9c65-2cc57c112171&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate,isAdvertisement,imagePath",
      :genre => "Documentary"
    },
    {
      :source => "Eleven",
      :name => "Being Human | Full Episodes",
      :data_url => "http://api.v2.movideo.com/rest/playlist/45050?depth=1&token=5c8d7056-1d4e-44de-967d-13731df0d3d8&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate,isAdvertisement,imagePath",
      :genre => ''
    },
    {
      :source => "Neighbours",
      :name => "Neighbours",
      :data_url => "http://api.v2.movideo.com/rest/playlist/41267?depth=1&token=5c8d7056-1d4e-44de-967d-13731df0d3d8&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate,isAdvertisement,imagePath",
      :genre => "Drama"
    }
  ]

  tv_shows.each do |show_data|
    source_name = show_data.delete(:source)

    collection = Source.where(:name => source_name).first.tv_shows

    Source.find_or_create(collection, :name, show_data)
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
  },
  "Angry Boys" => {
    "name" => "Angry Boys",
    "description" => nil,
    "classification" => nil,
    "genre" => "Comedy",
    "image" => "http://www.abc.net.au/reslib/201105/r763726_6441373.jpg"
  },
  "The Catherine Tate Show" => {
    "name" => "The Catherine Tate Show",
    "description" => nil,
    "classification" => nil,
    "genre" => "Comedy",
    "image" => "http://www.abc.net.au/reslib/201007/r600879_3911401.jpg"
  },
  "Pat And Stan" => {
    "name" => "Pat And Stan",
    "description" => nil,
    "classification" => nil,
    "genre" => "Abc3",
    "image" => "http://www.abc.net.au/reslib/200907/r392871_1838133.jpg"
  },
  "Doctor Who: Adventures In The Human Race " => {
    "name" => "Doctor Who: Adventures In The Human Race ",
    "description" => nil,
    "classification" => nil,
    "genre" => "Drama",
    "image" => "http://www.abc.net.au/reslib/201105/r776210_6644927.jpg"
  },
  "Baby Baby" => {
    "name" => "Baby Baby",
    "description" => "Following fifteen couples through the trials and triumphs of having multiple births. The real impact of twins and triplets in the twenty first century.",
    "classification" => nil,
    "genre" => "Parenting",
    "image" => "http://images.smh.com.au/2011/03/30/2259486/BabyBabyTitle169online-640x360.jpg"
  },
  "Totally Wild" => {
    "name" => "Totally Wild",
    "description" => nil,
    "classification" => nil,
    "genre" => "Children's TV",
    "image" => "http://media.movideo.com/images/53/playlist/41457/96x128.png"
  },
  "America's Port" => {
    "name" => "America's Port",
    "description" => nil,
    "classification" => nil,
    "genre" => "Documentary",
    "image" => "http://media.movideo.com/images/246/playlist/45405/96x128.png"
  },
  "Being Human | Full Episodes" => {
    "name" => "Being Human | Full Episodes",
    "description" => nil,
    "classification" => nil,
    "genre" => '',
    "image" => "http://media.movideo.com/images/220/playlist/45050/96x128.png"
  },
  "Neighbours" => {
    "name" => "Neighbours",
    "description" => nil,
    "classification" => nil,
    "genre" => "Drama",
    "image"=>"http://media.movideo.com/images/89/playlist/41267/96x128.png"
  }
}
