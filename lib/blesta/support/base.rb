module Blesta
  class Base

    def initialize
      @conn = Faraday.new(:url => Blesta.config[:base_uri]) do |c|
        c.request  :url_encoded
        c.response :json
        c.adapter  :net_http
      end
    end

    # Public: Indicates whether the request was successful or not
    #
    # Returns boolean
    def successful?
      @success
    end

    # Public: authentication parameters
    #
    # Returns a hash
    def authentication_params
      {
        :uid      => Blesta.config[:uid],
        :password => Blesta.config[:password]
      }
    end

    # Public: Peforms an HTTP Request
    #
    # request_method - The HTTP request method for the #request.
    # (:get/:post/:delete etc)
    # path           - URL path
    # options        - HTTP query params
    #
    # Examples
    #
    #   request :get, '/something.json' # GET /seomthing.json
    #   request :put, '/something.json', :something => 1
    #     # PUT /something.json?something=1
    #
    # Returns the parsed json response
    def request(request_method, path, options = {})
      check_config!

      params = (options[:query] || {}).merge authentication_params
      response = @conn.send(request_method, path, params)
      @success = (response.body['response_code'].to_s == '200')

      response.body
    end

    private

    # Private: Raises an error if a request is made without first calling
    # Blesta.config
    def check_config!
      raise NoConfig, "Blesta.config must be specified" if Blesta.config.empty?
    end

    # Private: returns the response data if request was succesfull
    # or a hash that contains the error code and message
    #
    # response - the blesta response
    def response_data_or_error(response)
      if successful?
        block_given? ? yield : response['data']
      else
        { :error_code => response["response_code"],
          :message => response["response_text"] }
      end
    end
  end
end
