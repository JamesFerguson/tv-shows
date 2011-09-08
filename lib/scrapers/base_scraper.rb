require 'shellwords'

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
    raise "Attempted to read_url('#{url}')" if Rails.env == 'test' # since fakeweb won't catch curl

    `curl --silent -L #{Shellwords.shellescape(url)}`
  end
end
