require 'spec_helper'

describe Blesta::Credit do
  let(:faraday_request_stub) { Faraday::Adapter::Test::Stubs.new }
  let(:credit) { Blesta::Credit.new }

  before do
    credit.instance_variable_get(:@conn).builder.
      swap Faraday::Adapter::NetHttp,
        Faraday::Adapter::Test, faraday_request_stub
  end

  def stub_faraday_request(params, response)
    query_param = build_query_params params
    faraday_request_stub.get(query_param) { [200, {}, response] }
  end

  describe '#get_amount' do
    let (:params) { {:action => "getcredit"} }

    context 'on success' do
      it 'should return the amount of credit in USD' do
        response = blesta_successful_response "10.00"
        stub_faraday_request(params, response)

        response = credit.get_amount
        faraday_request_stub.verify_stubbed_calls
        response.should == "10.00"
      end
    end

    context 'on error' do
      it 'returns a hash that contains the error code and message' do
        params = {"action" => "getcredit" }
        response = blesta_unsuccessful_response "100","Authentication failed"
        stub_faraday_request(params, response)

        response = credit.get_amount
        credit.should_not be_successful
        response[:error_code].should == "100"
        response[:message].should    == "Authentication failed"
      end
    end
  end
end
