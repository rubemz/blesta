require 'faraday'
require 'faraday_middleware'
require 'blesta/support/version'

module Blesta
  autoload :Config,     'blesta/support/config'
  autoload :Base,       'blesta/support/base'
  autoload :License,    'blesta/license'
  autoload :Package,    'blesta/package'
  autoload :Credit,     'blesta/credit'

  # Config
  extend self
  attr_accessor :configuration

  attr_accessor :configuration_file

  self.configuration ||= Blesta::Config.new

  # Public: Specificy the config via block
  #
  # base_uri - URL of your Blesta Resellers API`
  # uid      - API UID
  # password - API Password
  #
  # Examples
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
