require 'spec_helper'

describe Blesta::Package do
  let(:faraday_request_stub) { Faraday::Adapter::Test::Stubs.new }
  let(:package) { Blesta::Package.new }

  before do
    package.instance_variable_get(:@conn).builder.
      swap Faraday::Adapter::NetHttp,
        Faraday::Adapter::Test, faraday_request_stub
  end

  def stub_faraday_request(params, response)
    query_param = build_query_params params
    faraday_request_stub.get(query_param) { [200, {}, response] }
  end

  describe '#all' do
    let (:params) { {:action => "getpackages"} }

    context 'on success' do
      it 'should return a list of all the packages' do
        response = blesta_successful_response [{"name" => "Blesta Monthly",
          "type" => "license","term" => "monthly","price" => "15.95"}]
        stub_faraday_request(params, response)

        response = package.all
        faraday_request_stub.verify_stubbed_calls
      end
    end

    context 'on error' do
      it 'returns a hash that contains the error code and message' do
        params = {"action" => "getpackages" }
        response = blesta_unsuccessful_response "100","Authentication failed"
        stub_faraday_request(params, response)

        response = package.all
        package.should_not be_successful
        response[:error_code].should == "100"
        response[:message].should    == "Authentication failed"
      end
    end
  end
end
