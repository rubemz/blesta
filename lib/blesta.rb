require 'blesta/support/version'

module Blesta
  autoload :Config,     'blesta/support/config'

  # Config
  extend self
  attr_accessor :configuration

  attr_accessor :configuration_file

  self.configuration ||= Blesta::Config.new

  # Public: Specificy the config via block
  #
  # ==== Attributes
  #
  # * +base_uri+ - URL of your Blesta Resellers API`
  # * +uid+ - API UID
  # * +password+ - API Password
  #
  # ==== Example
  #
  #   Blesta.config do |c|
  #     c.base_uri 'http://test.com/reseller'
  #     c.uid '1234'
  #     c.password 'mypass'
  #   end
  #
  # Returns a Hash
  def config
    yield self.configuration if block_given?
    self.configuration.config
  end

  # Public: Reset the config (aka, clear it)
  def reset_config
    self.configuration = Blesta::Config.new
  end

end
