# Ensure that in tests, we get a consistent domain back from Plek < 1.0.0
# Without this, content API tests re chunking of requests with long URLs would
# pass/fail in dev/CI.
ENV['RACK_ENV'] = "test"

require 'bundler'
Bundler.setup :default, :development, :test

require 'minitest/autorun'
require 'rack/utils'
require 'simplecov'
require 'simplecov-rcov'
require 'mocha'
require 'timecop'

SimpleCov.start do
  add_filter "/test/"
  add_group "Test Helpers", "lib/gds_api/test_helpers"
  formatter SimpleCov::Formatter::RcovFormatter
end

class MiniTest::Unit::TestCase
  def teardown
    Timecop.return
  end
end

require 'webmock/minitest'
WebMock.disable_net_connect!
