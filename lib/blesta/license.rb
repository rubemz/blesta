module Blesta
  class License < Base
    TERM_OPTIONS          = ["owned", "monthly", "yearly"]
    TERM_OPTIONS_ERROR    = "valid term options are owned, monthly, yearly"

    # Public: Sets the test mode.
    attr_writer :test_mode

    # Public: Gets the test mode value. Default value is false.
    def test_mode
      @test_mode || false
    end

    # Public: Returns all licenses
    #
    # Returns a hash where the keys are the license IDs
    def all
      response = request(:get, '', {:query => {:action=> 'getlicenses'}})
      response_data_or_error response
    end

    # Public: Adds a new license. Even though the Blesta Reseller API
    # documentation states that the addlicense returns a list of licenses, in
    # fact, it just returns a license object.
    #
    # term      - The term that should apply to this license. Options are:
    # owned, monthly, yearly
    # options   - options hash. It should include a domain and prorate option
    # is optional (defaul is false)
    #
    # Returns a Hash that contains the license and domain keys
    def add(term, options={})
      raise ArgumentError, TERM_OPTIONS_ERROR unless TERM_OPTIONS.include?(term)

      license_params = { :term =>term, :action=>'addlicense',
        :test_mode => test_mode }.merge(options)
      response = request(:get, '', {:query => license_params})
      response_data_or_error response
    end

    # Public: Permanently cancels the given license
    #
    # license_id - The license key for this license
    #
    # Returns nil. In case of error, it returns a hash that contains the
    # error code and message
    def cancel(license_id)
      basic_request(license_id, "cancellicense")
    end

    # Public: Indefinitely suspend a license
    #
    # license_id - The license key for this license
    #
    # Returns nil. In case of error, it returns a hash that contains the
    # error code and message
    def suspend(license_id)
      basic_request(license_id, "suspendlicense")
    end

    # Public: Unsuspend a previously suspended license
    #
    # license_id - The license key for this license
    #
    # Returns nil. In case of error, it returns a hash that contains the
    # error code and message
    def unsuspend(license_id)
      basic_request license_id, "unsuspendlicense"
    end

    # Public: Updates the domain for this license
    #
    # license_id - The license you wish to update
    # options    - options hash. It should include a domain.
    #
    # Returns nil. In case of error, it returns a hash that contains the
    # error code and message
    def update_domain(license_id, options={})
      update_params = { :action => "updatedomain",
        :license => license_id }.merge(options)
      response = request(:get, '', {:query => update_params})
      response_data_or_error response
    end

    # Public: Search through all available licenses for a match
    #
    # term    - either a domain or license, depending on the search type
    # options - hash options (default: {}):
    #           :type - domain or license as string (required)
    #           :page - the page of results to return. Results are limited to
    #                   25 per page (optional)
    #
    # Returns a list of licenses that matched the criteria
    def search(term, options={})
      search_params = { :action => "searchlicenses",
        :search => { options[:type] => term}}.merge(options)
      response = request(:get, '', {:query => search_params})
      response_data_or_error response
    end

    private
    # Private: Makes a basic license request
    #
    # license_id: The license id
    # action: The specific action that you want to perform
    #
    # Return the response data or, in case of error, it returns a hash that
    # contains the error code and message
    def basic_request(license_id, action)
      params = { :action => action, :license => license_id,
        :test_mode => test_mode.to_s }
      response = request(:get, '', {:query => params})
      response_data_or_error response
    end
  end
end
