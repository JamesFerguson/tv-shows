module FakewebHelper
  def fakewebize(url)
    url = url.gsub(%r{/}, '^').gsub(%r{&token=[^&]+|&omitFields=[^&]+}, '')
    url = (url !~ /(\.html?|\.xml)$/ ? url + '.htm' : url)
  end
end
