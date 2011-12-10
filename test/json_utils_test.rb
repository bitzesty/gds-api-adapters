require_relative 'test_helper'
require 'gds_api/json_utils'
require 'rack'

StubRackApp = lambda do |env|
  sleep(30)
  body = '{"some":"value"}'
  [200, {"Content-Type" => "text/plain", "Content-Length" => body.length.to_s}, [body]]
end

class JsonUtilsTest < MiniTest::Unit::TestCase
  include GdsApi::JsonUtils

  # def test_long_requests_timeout
  #   stub_request(:get, "www.example.com/timeout.json").to_rack(StubRackApp)
  #   assert_nil get_json("http://www.example.com/timeout.json")
  # end
  #
  # def test_get_raises_exception_on_timeout
  #   url = "http://some.endpoint/some.json"
  #   stub_request(:get, url).to_raise(Timeout::Error)
  #   assert_nil get_json(url)
  # end
  #
  # def test_post_returns_nil_on_timeout
  #   url = "http://some.endpoint/some.json"
  #   stub_request(:post, url).to_raise(Timeout::Error)
  #   assert_nil post_json(url, {})
  # end

  def test_get_should_raise_endpoint_not_found_if_connection_refused
    url = "http://some.endpoint/some.json"
    stub_request(:get, url).to_raise(Errno::ECONNREFUSED)
    assert_raises GdsApi::EndpointNotFound do
      get_json(url)
    end
  end

  def test_post_should_raise_endpoint_not_found_if_connection_refused
    url = "http://some.endpoint/some.json"
    stub_request(:get, url).to_raise(Errno::ECONNREFUSED)
    assert_raises GdsApi::EndpointNotFound do
      get_json(url)
    end
  end

  def test_should_fetch_and_parse_json_into_hash
    url = "http://some.endpoint/some.json"
    stub_request(:get, url).to_return(:body => "{}",:status => 200)
    assert_equal Hash, get_json(url).class
  end

  def test_should_return_nil_if_404_returned_from_endpoint
    url = "http://some.endpoint/some.json"
    stub_request(:get, url).to_return(:body => "{}", :status => 404)
    assert_nil get_json(url)
  end
end