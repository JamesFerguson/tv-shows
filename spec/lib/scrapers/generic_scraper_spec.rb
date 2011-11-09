require 'spec_helper'

describe "each scraper" do
  include FakewebHelper

  before(:all) do
    FakeWeb.allow_net_connect = false
    seed_sources
    seed_tv_shows
  end

  after(:all) do
    Source.destroy_all
    TvShow.destroy_all
  end

  it "has a tv_show seeded" do
    Source.all.each do |source|
      source.tv_shows.count.should > 0
    end
  end

  it "excludes slideshow, poll, etc when parsing channel nine" do
    source = Source.where(:name => "NineMSN Fixplay").first
    fake_page(NineScraper, source.url)

    NineScraper.extract_shows(NineScraper.extract_all_source_urls(source.url).first).
      map do |show_data|
        URI.parse(show_data[:data_url]).host
      end.
        uniq.should == ["fixplay.ninemsn.com.au"]
  end

  context "after faking scrapers' source urls" do
    before(:each) do
      fake_extract_all_source_urls_pages
    end

    it "scrapes the index for each source ok" do
      Source.all.each do |source|
        show_urls = source.scraper_class.extract_all_source_urls(source.url)

        shows = show_urls.map do |url|
          download_page_if_new(source, url)
          fake_page(source.scraper_class, url)

          source.scraper_class.extract_shows(url).map(&:stringify_keys)
        end.flatten

        prefill_results_if_new(source, source.url, shows)

        shows.should == JSON.parse(File.read("spec/fakeweb/results/#{fakewebize(source.url)}.json"))
      end
    end

    it "scrapes the episodes for each show ok" do
      Source.all.each do |source|
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
    end
  end
end


