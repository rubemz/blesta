module Blesta
  class Base

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
    # request_method - The HTTP request method for the #request. (:get/:post/:delete etc)
    # path           - URL path
    # options        - HTTP query params
    #
    # Examples
    #
    #   request :get, '/something.json' # GET /seomthing.json
    #   request :put, '/something.json', :something => 1 # PUT /something.json?something=1
    #
    # Returns the parsed json response
    def request(request_method, path, options = {})
      check_config!

      conn = Faraday.new(:url => Blesta.config[:base_uri]) do |c|
        c.params = (options[:query] || {}).merge authentication_params
        c.request  :url_encoded
        c.response :json
        c.adapter  :net_http
      end

      response = conn.send(request_method, path)
      @success = (response.body['response_code'] == '200')

      response.body
    end

    private

    # Private: Raises an error if a request is made without first calling Blesta.config
    def check_config!
      raise NoConfig, "Blesta.config must be specified" if Blesta.config.empty?
    end

  end
end
