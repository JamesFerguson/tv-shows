def seed_tv_shows
  tv_shows = [
    {
      :source => "Channel Nine",
      :name => "AFP",
      :url => "http://fixplay.ninemsn.com.au/afp"
    },
    {
      :source => "Channel Seven",
      :name => "Winners and Losers",
      :url => "http://au.tv.yahoo.com/plus7/winners-and-losers/"
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
      :name => "TNT Jackson ",
      :url => "http://www.abc.net.au/reslib/201105/r764592_6456606.jpg"
    },
    {
      :source => "SMH.tv",
      :name => "Baby Baby",
      :url => "http://www.smh.com.au/tv/show/baby-baby-20110308-1bm6s.html"
    }
  ]

  tv_shows.each do |show_data|
    source_name = show_data.delete(:source)

    Source.where(:name => source_name).first.tv_shows.make(show_data)
  end
end