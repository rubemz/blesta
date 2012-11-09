require 'blesta'
require 'vcr'
require 'fakeweb'
require 'json'

def mock_request(meth, path, options = {})
  uri    = URI.parse(Blesta.config[:base_uri])
  url    = "#{uri.scheme}://#{uri.host}:#{uri.port}#{path}"
  FakeWeb.register_uri(meth, url, {:content_type => 'application/json'}.merge(options))
end

RSpec.configure do |c|
  c.before(:each) do
    configure_for_tests
  end
  c.after(:each) do
    Blesta.reset_config
  end
end

def configure_for_tests
  Blesta.config do |c|
    c.uid "12345"
    c.password "test"
    c.base_uri "http://example.com"
  end
end
