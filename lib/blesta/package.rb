module Blesta
  class Package < Base

    # Public: Fetches a list of all of the packages this reseller account may
    #
    # Returns a list of all of the packages
    def all
      response = request(:get, '', {:query => {:action=> 'getpackages'}})
      response_data_or_error response
    end

  end
end
