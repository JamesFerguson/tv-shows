class BaseScraper
  def self.extract_show_urls(source_url)
    [source_url]
  end

  def self.extract_shows(source_urls)
    raise "BaseScraper method called. Method should be implemented by #{self.class.name}"
  end

  def self.extract_episodes(show)
    raise "BaseScraper method called. Method should be implemented by #{self.class.name}"
  end

  protected

  def self.read_url(url)
    `curl --silent #{url.to_s}`
  end
end