require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "#{::Rails.root}/spec/cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.configure_rspec_metadata!
  #config.ignore_request do |request|
  #  reg = Regexp.new("http://ipinfo.io/161.185.207.20/.*")
  #  request.uri =~ reg
  #end
end
