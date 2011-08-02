module FakewebHelper
  def fakewebize(url)
    url = url.gsub(%r{/}, '^')[0...([340, url.size].min)]
    url = (url !~ /(\.html?|\.xml)$/ ? url + '.htm' : url)
  end
end
