module AbcXmlParser
  class Item
    include HappyMapper
    tag 'item'

    element :name, String, :tag => 'title'
    element :thumbnail_url, String, :tag => 'media:thumbnail/@url'
    element :link, String
    element :description, String
    element :genre, String, :tag => 'category'
    element :duration, Integer, :tag => 'media:content/@duration'
  end
end
