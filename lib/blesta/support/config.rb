module Blesta
  # Holds the configuration for Blesta
  class Config
    attr_accessor :config

    def initialize
      @config = {}
    end

    # Public: get the configuration value
    #
    # configuration - the configuration key
    #
    # Returns the configuration value or nil if it has not been set
    def [](configuration)
      @config[configuration]
    end

    # Public: set the base uri for Blesta resellers API
    #
    # value - uri for Blesta resellers API
    #
    # Returns the given base uri
    def base_uri(value)
      @config[:base_uri]  = value
    end

    # Public: set the Blesta reseller UID
    #
    # value - UID for Blesta resellers API
    #
    # Returns the given UID
    def uid(value)
      @config[:uid] = value
    end

    # Public: set the Blesta reseller password
    #
    # value - password for Blesta resellers API
    #
    # Returns the given password
    def password(value)
      @config[:password] = value
    end
  end
end
