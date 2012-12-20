require 'blesta'
require 'vcr'
require 'fakeweb'
require 'json'

def mock_request(meth, path, options = {})
  uri    = URI.parse(Blesta.config[:base_uri])
  url    = "#{uri.scheme}://#{uri.host}:#{uri.port}#{path}"
  FakeWeb.register_uri(meth, url, {:content_type => 'application/json'}.
                       merge(options))
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

def blesta_successful_response(data)
  successful_response = {
    "response_code" => 200,
    "response_text" => "OK",
    "data" => data
  }
  JSON.generate(successful_response)
end

def blesta_unsuccessful_response(code, message="error")
  successful_response = {
    "response_code" => code,
    "response_text" => message,
    "data" => nil
  }
  JSON.generate(successful_response)
end

def getlicenses_response
  license_response = {
    "ABCDEFGH12345678" => [{
      "type" => "license",
      "license" => "ABCDEFGH12345678",
      "domain" => "domain.com",
      "term" => "monthly",
      "date_added" => "2009-07- 24",
      "date_suspended" => "0000-00-00",
      "date_renews" => "2009-10- 01",
    }]
  }
  blesta_successful_response license_response
end

def getlicenses_search_response
  search_response = [{
    "id" => "616",
    "domain" => "mydomain.com",
    "license" => "ABCDEFGH01234567",
    "last_callback" => "",
    "term" => "0"
  },{
    "id" => "617",
    "domain" => "test.com",
    "license" => "ABCDEFGH01234568",
    "last_callback" => "",
    "term" => "0"
  }]
  blesta_successful_response search_response
end

def build_query_params(params={})
  base = Blesta::Base.new
  params = params.merge base.authentication_params
  require 'active_support/core_ext'
  "?#{params.to_query}"
end

def mock_blesta_request(body, params = {})
  mock_request(:get, "/api" + build_query_params(params),
               :status => [200, "OK"], :body => body)
end
