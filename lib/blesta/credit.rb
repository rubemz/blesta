module Blesta
  class Credit < Base

    # Public: Fetch the amount of credit in USD on the reseller account
    #
    # Returns the amount of credit in USD
    def get_amount
      response = request(:get, '', {:query => {:action=> 'getcredit'}})
      response_data_or_error response
    end

  end
end
