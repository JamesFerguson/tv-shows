# Preload all the scrapers
Dir[Rails.root.join("lib/scrapers/**/*.rb")].each {|f| require f}
