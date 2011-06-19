class BaseScraper
  def self.extract_shows(source_url)
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