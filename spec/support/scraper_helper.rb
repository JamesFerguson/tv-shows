module ScraperHelper
  def scrape_shows_index_spec(source)
    show_urls = fake_extract_shows_pages(source)

    shows = show_urls.map { |url| source.scraper_class.extract_shows(url).map(&:stringify_keys) }.flatten

    prefill_results_if_new(source, source.url, shows)

    shows.should == JSON.parse(File.read("spec/fakeweb/results/#{fakewebize(source.url)}.json"))
  end

  def fake_extract_shows_pages(source, instances = 1)
    fake_extract_all_source_urls_pages(source, instances)

    show_urls = source.scraper_class.extract_all_source_urls(source.url)

    show_urls.each do |url|
      download_page_if_new(source, url)
      fake_page(source.scraper_class, url)
    end

    show_urls
  end

  def scrape_show_episodes(source)
    fake_extract_all_source_urls_pages(source)

    source.scraper_class.extract_all_source_urls(source.url) # sets up values for some scrapers (e.g. token for Ten)

    show = source.tv_shows.first
    if Source.where(scraper: ['TenScraper', 'TenMicroSiteScraper']).include? source
      token = source.scraper_class.class_variable_get(:@@token)
      show.data_url = show.data_url.sub(/token=[^&]+&/, "token=#{token}&")
    end

    puts show.name if ENV['DEBUG']
    url = show.data_url
    ext = "#{url == source.url ? '.ep' : ''}.json"

    download_page_if_new(source, url)
    fake_page(show.source.scraper_class, url)

    results = show.source.scraper_class.extract_episodes(show)

    prefill_results_if_new(source, url, results, ext)

    results.map(&:stringify_keys).should == JSON.parse(File.read("spec/fakeweb/results/#{fakewebize(url)}#{ext}"))
    show.attributes.slice(*%w{name description classification genre image}).should == SEEDED_SHOW_ATTRS[show.name]
  end

  def download_page_if_new(source, url)
    if first_scrape?(source)
      puts "First Scrape: #{url}" if ENV['DEBUG']

      download_page(url)
    else
      puts "Not first scrape: #{source.name}" if ENV['DEBUG']
    end
  end

  def first_scrape?(source)
    ((ENV['FIRST_SCRAPE'] || '').split(',') & [source.name, source.scraper, 'All']).any?
  end

  def download_page(url)
    `curl --silent -L #{Shellwords.shellescape(url)} >#{Shellwords.shellescape((Rails.root + "spec/fakeweb/pages/#{fakewebize(url)}").to_s)}`
  end


  def prefill_results_if_new(source, url, results, ext = '.json')
    if first_results?(source)
      puts "First Results: #{url}" if ENV['DEBUG']

      prefill_results(source, url, results, ext)
    else
      puts "Not first results: #{source.name}" if ENV['DEBUG']
    end
  end

  def first_results?(source)
    ((ENV['FIRST_RESULTS'] || '').split(',') & [source.name, source.scraper, 'All']).any?
  end

  def prefill_results(source, url, results, ext = '.json')
    puts "Writing the following json to spec/fakeweb/results/#{fakewebize(url)}#{ext} for #{source.name}:"
    ap results
    File.open(Rails.root.join("spec/fakeweb/results/#{fakewebize(url)}#{ext}"), 'w') { |f| f.puts results.to_json }
  end


  def fake_extract_all_source_urls_pages(source, instances = 1)
    return unless ['SmhScraper', 'TenScraper', 'TenMicroSiteScraper'].include?(source.scraper)

    download_page_if_new(source, source.url)

    fake_page(source.scraper.constantize, source.url, instances)
  end

  def fake_page(scraper, url, instances = 1)
    scraper.should_receive(:read_url).with(url).exactly(instances).times.and_return(File.read(Rails.root + "spec/fakeweb/pages/#{fakewebize(url)}"))
  end


  def fakewebize(url)
    url = url.gsub(%r{/}, '^').gsub(%r{&token=[^&]+|&omitFields=[^&]+}, '')
    url = (url !~ /(\.html?|\.xml)$/ ? url + '.htm' : url)
  end
end
