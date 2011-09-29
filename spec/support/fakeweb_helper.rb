module FakewebHelper
  def fakewebize(url)
    url = url.gsub(%r{/}, '^').gsub(%r{&token=[^&]+|&omitFields=[^&]+}, '')
    url = (url !~ /(\.html?|\.xml)$/ ? url + '.htm' : url)
  end

  def first_scrape?(source)
    ((ENV['FIRST_SCRAPE'] || '').split(',') & [source.name, source.scraper]).any?
  end

  def first_results?(source)
    ((ENV['FIRST_RESULTS'] || '').split(',') & [source.name, source.scraper]).any?
  end
end
