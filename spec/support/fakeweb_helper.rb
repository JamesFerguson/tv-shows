module FakewebHelper
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


  def fake_extract_all_source_urls_pages(instances = 1)
    # Some scrapers call read_url for extract_all_source_urls
    Source.where("sources.scraper IN ('SmhScraper', 'TenScraper', 'TenMicroSiteScraper')").each do |source|
      download_page_if_new(source, source.url)

      fake_page(source.scraper.constantize, source.url, instances)
    end
  end

  def fake_page(scraper, url, instances = 1)
    scraper.should_receive(:read_url).with(url).exactly(instances).times.and_return(File.read(Rails.root + "spec/fakeweb/pages/#{fakewebize(url)}"))
  end


  def fakewebize(url)
    url = url.gsub(%r{/}, '^').gsub(%r{&token=[^&]+|&omitFields=[^&]+}, '')
    url = (url !~ /(\.html?|\.xml)$/ ? url + '.htm' : url)
  end
end
