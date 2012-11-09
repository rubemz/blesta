require 'spec_helper'

describe Blesta::Config do
  let(:config) { Blesta::Config.new }

  describe '#new' do
    it 'sets up the @config hash' do
      config.config.should == {}
    end
  end

  describe "#[]" do
    it "behaves like an array" do
      config.config[:something] = 1
      config[:something].should == 1
    end
  end

  describe "#base_uri" do
    it "sets the base_uri" do
      config.config[:base_uri].should be_nil
      config.base_uri 'url'
      config.config[:base_uri].should == 'url'
    end
  end

  describe "#uid" do
    it "sets the uid" do
      config.config[:uid].should be_nil
      config.uid '1234'
      config.config[:uid].should == '1234'
    end
  end

  describe "#password" do
    it "sets the password" do
      config.config[:password].should be_nil
      config.password 'pass'
      config.config[:password].should == 'pass'
    end
  end
end
