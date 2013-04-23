def seed_tv_shows
  tv_shows = [
    {
      source: "NineMSN Fixplay",
      name: "The Farmer Wants a Wife",
      data_url: "http://fixplay.ninemsn.com.au/thefarmerwantsawife"
    },
    {
      source: "Yahoo Plus7",
      name: "Home and Away",
      data_url: "http://au.tv.yahoo.com/plus7/home-and-away/"
    },
    {
      source: "ABC 1",
      name: "Lateline",
      data_url: "http://tviview.abc.net.au/iview/rss/category/abc1.xml",
      homepage_url: "http://www.abc.net.au/iview/#/view/829820",
      image: "http://www.abc.net.au/reslib/201006/r581475_3661101.jpg",
      genre: "News"
    },
    {
      source: "ABC 2",
      name: "Good Game",
      data_url: "http://tviview.abc.net.au/iview/rss/category/abc2.xml",
      homepage_url: "http://www.abc.net.au/iview/#/view/846379",
      image: "http://www.abc.net.au/reslib/201104/r749673_6204464.jpg",
      genre: "Lifestyle"
    },
    {
      source: "ABC 3",
      name: "The Legend of Dick and Dom",
      data_url: "http://tviview.abc.net.au/iview/rss/category/abc3.xml",
      homepage_url: "http://www.abc.net.au/iview/#/view/630135",
      image: "http://www.abc.net.au/reslib/201008/r629538_4281189.jpg",
      genre: "Abc3"
    },
    {
      source: "iView Originals",
      name: "Rage Highlights",
      data_url: "http://tviview.abc.net.au/iview/rss/category/original.xml",
      homepage_url: "http://www.abc.net.au/iview/#/view/844703",
      image: "http://www.abc.net.au/reslib/201107/r806055_7149136.jpg",
      genre: "Arts"
    },
    {
      source: "SMH.tv",
      name: "Baby Baby",
      data_url: "http://www.smh.com.au/tv/show/baby-baby-20110308-1bm6s.html"
    },
    {
      source: "Ten",
      name: "Totally Wild",
      data_url: "http://api.v2.movideo.com/rest/playlist/41457?depth=1&token=23789ee7-a6ee-48f0-9931-4fa85965baf3&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate,isAdvertisement,imagePath",
      genre: "Children's TV"
    },
    {
      source: "OneHd",
      name: "RPM | Full Episodes",
      data_url: "http://api.v2.movideo.com/rest/playlist/44315?depth=1&token=1d43e9b0-1352-4b34-9c65-2cc57c112171&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate,isAdvertisement,imagePath",
      genre: "Sports Shows"
    },
    {
      source: "Eleven",
      name: "CouchTime | Full Episodes",
      data_url: "http://api.v2.movideo.com/rest/playlist/44060?depth=1&token=5c8d7056-1d4e-44de-967d-13731df0d3d8&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate,isAdvertisement,imagePath",
      genre: ''
    },
    {
      source: "Neighbours",
      name: "Neighbours",
      data_url: "http://api.v2.movideo.com/rest/playlist/41267?depth=1&token=5c8d7056-1d4e-44de-967d-13731df0d3d8&mediaLimit=50&includeEmptyPlaylists=false&omitFields=client,copyright,mediaSchedules,cuePointsExist,encodingProfiles,filename,imageFilename,mediaFileExists,mediaType,ratio,status,syndicated,tagProfileId,advertisingConfig,tagOptions,podcastSupported,syndicatedPartners,creationDate,lastModifiedDate,isAdvertisement,imagePath",
      genre: "Drama"
    }
  ]

  tv_shows.each do |show_data|
    source_name = show_data.delete(:source)

    collection = Source.where(name: source_name).first.tv_shows

    Source.find_or_create(collection, :name, show_data)
  end
end

def seed_sources
  load Rails.root.join('db/seeds.rb')
end

SEEDED_SHOW_ATTRS = {
  "Home and Away" => {
    "name" => "Home and Away",
    "description" => "Following the lives and loves of the residents of Summer Bay in this long-running Australian drama series. Stars Ray Meagher as Alf Stewart, Lynne McGranger as Irene Roberts and Steve Peacocke as Daryl Braxton",
    "classification"=>"5K\n                ",
    "genre"=>"Soap Opera",
    "image"=>"http://l.yimg.com/ao/i/tv/portal/promos/h&a_p7_thumbnail_aw.jpg"
  },
  "The Farmer Wants a Wife" => {
    "name" => "The Farmer Wants a Wife",
    "description" => "City meets country in this fun-filled Australian series. Follow six lonely farmers on the road to romance as they choose between hundreds of prospective partners. Prepare for tears, joy and jealousy, all in a heart-warming journey to find a wife. Hosted by Natalie Gruzlewski.\n",
    "classification" => nil,
    "genre" => "Reality",
    "image" => "http://fixplay.ninemsn.com.au/img/all_Show_section/FWAW7.jpg"
  },
  "Lateline" => {
    "name" => "Lateline",
    "description" => nil,
    "classification" => nil,
    "genre" => "News",
    "image"=>"http://www.abc.net.au/reslib/201006/r581475_3661101.jpg"
  },
  "Good Game" => {
    "name" => "Good Game",
    "description" => nil,
    "classification" => nil,
    "genre" => "Lifestyle",
    "image" => "http://www.abc.net.au/reslib/201104/r749673_6204464.jpg"
  },
  "The Legend of Dick and Dom" => {
    "name" => "The Legend of Dick and Dom",
    "description" => nil,
    "classification" => nil,
    "genre" => "Abc3",
    "image" => "http://www.abc.net.au/reslib/201008/r629538_4281189.jpg"
  },
  "Rage Highlights" => {
    "name" => "Rage Highlights",
    "description" => nil,
    "classification" => nil,
    "genre" => "Arts",
    "image" => "http://www.abc.net.au/reslib/201107/r806055_7149136.jpg"
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
  "RPM | Full Episodes" => {
    "name" => "RPM | Full Episodes",
    "description" => nil,
    "classification" => nil,
    "genre" => "Sports Shows",
    "image" => "http://media.movideo.com/images/161/playlist/44315/96x128.png"
  },
  "CouchTime | Full Episodes" => {
    "name" => "CouchTime | Full Episodes",
    "description" => nil,
    "classification" => nil,
    "genre" => '',
    "image" => "http://media.movideo.com/images/147/playlist/44060/96x128.png"
  },
  "Neighbours" => {
    "name" => "Neighbours",
    "description" => nil,
    "classification" => nil,
    "genre" => "Drama",
    "image"=>"http://media.movideo.com/images/89/playlist/41267/96x128.png"
  }
}
