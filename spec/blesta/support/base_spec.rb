require 'spec_helper'

describe Blesta::Base do
  let(:base) { Blesta::Base.new }
  let(:successful_response) { JSON.generate({ :response_text => "OK", :response_code => "200" }) }
  let(:bad_response) { JSON.generate({:response_code => "100" }) }

  def mock_blesta_request(body, params = {})
    params = params.merge base.authentication_params
    params = "?" + params.keys.reverse.map do |key|
      "#{CGI::escape(key.to_s)}=#{CGI::escape(params[key])}"
    end.join('&')
    mock_request(:get, "/api" + params, :status => [200, "OK"], :body => body)
  end

  describe "#request" do
    it 'includes the blesta UID and password in the params' do
      mock_blesta_request successful_response
      base.request(:get, '/api')['response_text'].should == 'OK'
    end

    it 'merges any other request parameter' do
      query_param = { :merge => 'true' }
      mock_blesta_request successful_response, query_param
      base.request(:get, '/api', :query => query_param )['response_text'].should == 'OK'
    end
  end

  describe "#successful?" do
    context 'response_code is 200' do
      it 'is true' do
        mock_blesta_request successful_response
        base.request(:get, '/api')
        base.should be_successful
      end
    end
    context 'response_code is different than 200' do
      it 'is false' do
        FakeWeb.clean_registry
        mock_blesta_request bad_response
        base.request(:get, '/api')
        base.should_not be_successful
      end
    end
  end

  describe "#authentication parameters" do
    it "returns the authentication parameters given the Blesta configuration" do
      parameters = {
        :uid => Blesta.config[:uid],
        :password => Blesta.config[:password]
      }
      base.authentication_params.should == parameters
    end
  end

end
