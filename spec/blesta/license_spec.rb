require 'spec_helper'

describe Blesta::License do
  let(:faraday_request_stub) { Faraday::Adapter::Test::Stubs.new }
  let(:license) { Blesta::License.new }
  before do
    license.instance_variable_get(:@conn).builder.
      swap Faraday::Adapter::NetHttp,
        Faraday::Adapter::Test, faraday_request_stub
  end

  def stub_faraday_request(params, response)
    query_param = build_query_params params
    faraday_request_stub.get(query_param) { [200, {}, response] }
  end

  describe '#all' do
    let (:params) { {:action => "getlicenses"} }

    context "on success" do
      before :each do
        stub_faraday_request(params, getlicenses_response)
      end

      it 'should fetch all licenses' do
        licenses = license.all
        faraday_request_stub.verify_stubbed_calls
      end

      it 'returns a Hash where the keys are the license IDs' do
        licenses = license.all()
        licenses.should be_a Hash
        licenses.keys.should == ["ABCDEFGH12345678"]
        faraday_request_stub.verify_stubbed_calls
      end
    end

    context 'on error' do
      it 'returns a hash that contains the error code and message' do
        response = blesta_unsuccessful_response "100", "Authentication failed"
        stub_faraday_request(params, response)

        response = license.all()
        license.should_not be_successful
        response[:error_code].should == "100"
        response[:message].should    == "Authentication failed"
      end
    end
end

  describe '#add' do
    let (:domain) { 'mydomain.com' }
    let (:params) { {:action=>"addlicense", :term=>"monthly",
      :domain=>"mydomain.com", :test_mode => "false"} }

    context "on success" do
      before do
        response = blesta_successful_response [{"license"=>"ABCDEFGH12345678",
          "domain"=>"mydomain.com"}]
        stub_faraday_request(params, response)
      end

      it 'requires a term that is owned, monthly or yearly' do
        Blesta::License::TERM_OPTIONS.each do |t|
          expect { license.add(t, domain) }.to_not raise_error(ArgumentError)
        end
      end

      it 'raises an error when the term is not valid' do
        error_message = "valid term options are owned, monthly, yearly"
        expect{ license.add('invalid_term', domain) }.
          to raise_error(ArgumentError, error_message)
      end

      it 'adds a new license' do
        license.add("monthly", :domain => domain )
        faraday_request_stub.verify_stubbed_calls
      end

      it 'returns a Hash that contains the license id and domain' do
        response = license.add("monthly", :domain => domain)
        response['license'].should == "ABCDEFGH12345678"
        response['domain'].should  == "mydomain.com"
      end
    end

    context 'on error' do
      it 'returns a hash that contains the error code and message' do
        response = blesta_unsuccessful_response "103",
          "License already exists for that domain"
        stub_faraday_request(params, response)

        response = license.add("monthly", :domain => domain)
        license.should_not be_successful
        response[:error_code].should == "103"
        response[:message].should    == "License already exists for that domain"
      end
    end

    context 'on test mode' do
      it 'sends the test mode parameter' do
        test_mode_params = params.merge({:test_mode => "true"})
        response = blesta_successful_response []
        stub_faraday_request(test_mode_params, response)

        license.test_mode = true
        license.add("monthly", :domain => domain)
        faraday_request_stub.verify_stubbed_calls
      end
    end
  end

  describe '#cancel' do
    let (:params) { {:action=>"cancellicense", :license => "ABCDEFGH12345678",
      :test_mode => "false"} }

    context 'on success' do
      it 'cancels the license' do
        response = blesta_successful_response nil
        stub_faraday_request(params, response)

        license.cancel 'ABCDEFGH12345678'
        faraday_request_stub.verify_stubbed_calls
      end

      context 'on test mode' do
        it 'sends the test mode parameter' do
          test_mode_params = params.merge({:test_mode => "true"})
          response = blesta_successful_response nil
          stub_faraday_request(test_mode_params, response)

          license.test_mode = true
          license.cancel 'ABCDEFGH12345678'
          faraday_request_stub.verify_stubbed_calls
        end
      end
    end

    context 'on error' do
      it 'returns a hash that contains the error code and message' do
        response = blesta_unsuccessful_response "102", "License does not exist"
        stub_faraday_request(params, response)

        response = license.cancel 'ABCDEFGH12345678'
        license.should_not be_successful
        response[:error_code].should == "102"
        response[:message].should    == "License does not exist"
      end
    end

  end

  describe '#suspend' do
    let (:params) { {:action=>"suspendlicense", :license => "ABCDEFGH12345678",
      :test_mode => "false"} }

    context 'on success' do
      it 'suspends the license' do
        response = blesta_successful_response nil
        stub_faraday_request(params, response)

        license.suspend 'ABCDEFGH12345678'
        faraday_request_stub.verify_stubbed_calls
      end
    end

    context 'on error' do
      it 'returns a hash that contains the error code and message' do
        response = blesta_unsuccessful_response "102", "License does not exist"
        stub_faraday_request(params, response)

        response = license.suspend 'ABCDEFGH12345678'
        license.should_not be_successful
        response[:error_code].should == "102"
        response[:message].should    == "License does not exist"
      end
    end
  end

  describe '#unsuspend' do
    let(:params) { {:action=>"unsuspendlicense", :license => "ABCDEFGH12345678",
      :test_mode => "false"} }

    context 'on success' do
      it 'unsuspends the license' do
        response = blesta_successful_response nil
        stub_faraday_request(params, response)

        license.unsuspend 'ABCDEFGH12345678'
        faraday_request_stub.verify_stubbed_calls
      end
    end

    context 'on error' do
      it 'returns a hash that contains the error code and message' do
        response = blesta_unsuccessful_response "102", "License does not exist"
        stub_faraday_request(params, response)

        response = license.unsuspend 'ABCDEFGH12345678'
        license.should_not be_successful
        response[:error_code].should == "102"
        response[:message].should    == "License does not exist"
      end
    end
  end


  describe '#update_domain' do
    let (:params) { {:action=>"updatedomain", :license => 'ABCDEFGH12345678',
      :domain => 'newdomain.com' } }

    context 'on success' do
      it 'updates the domain for a given license' do
        response = blesta_successful_response nil
        stub_faraday_request(params, response)

        license.update_domain('ABCDEFGH12345678', :domain => 'newdomain.com')
        faraday_request_stub.verify_stubbed_calls
      end
    end

    context 'on error' do
      it 'returns a hash that contains the error code and message' do
        response = blesta_unsuccessful_response "103",
          "License already exists for that domain"
        stub_faraday_request(params, response)

        response = license.update_domain('ABCDEFGH12345678',
                                         :domain => 'newdomain.com')
        license.should_not be_successful
        response[:error_code].should == "103"
        response[:message].should    == "License already exists for that domain"
      end
    end
  end

  describe "#search" do
    context 'on success' do
      it 'returns a list of licenses that match the given domains' do
        params = {"action" => "searchlicenses", "search" =>
          { "domain" => "mydomain.com" }}
        stub_faraday_request(params, getlicenses_search_response)

        response = license.search "mydomain.com", :type => 'domain'
        faraday_request_stub.verify_stubbed_calls
        license.should be_successful
        response.should have(2).items
      end

      it 'returns a list of licenses that match the given licenses id' do
        params = {"action" => "searchlicenses", "search" =>
          { "license" => "ABCDEFGH12345678" }}
        stub_faraday_request(params, getlicenses_search_response)

        response = license.search "ABCDEFGH12345678", :type => 'license'
        faraday_request_stub.verify_stubbed_calls
        license.should be_successful
        response.should have(2).items
      end
    end
    context 'on error' do
      it 'returns a hash that contains the error code and message' do
        params = {"action" => "searchlicenses", "search" =>
          { "license" => "ABCDEFGH12345678" }}
        response = blesta_unsuccessful_response "100","Authentication failed"
        stub_faraday_request(params, response)

        response = license.search "ABCDEFGH12345678", :type => 'license'
        license.should_not be_successful
        response[:error_code].should == "100"
        response[:message].should    == "Authentication failed"
      end
    end
  end
end
