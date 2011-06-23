module FakewebHelper
  def fakewebize(url)
    url = url.gsub(%r{/}, '^')
    url = (url !~ /(\.html?|\.xml)$/ ? url + '.htm' : url)
  end
end