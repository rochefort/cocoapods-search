require 'coveralls'
Coveralls.wear!

require 'webmock/rspec'
require 'cocoapods/search'
require 'simplecov'
# require 'pry'
require 'rspec/its'
SimpleCov.start

RSpec.configure do |config|
  config.expose_dsl_globally = false
end

def load_http_stub(file_name)
  file_path = File.join(File.dirname(__FILE__), 'http_stubs', file_name)
  File.read(file_path)
end

def stub_request_on_github(github_url)
  project = github_url.split('/').last
  stub_request(:get, "https://github.com/#{github_url}")
    .with(headers: { 'Accept'=>'*/*' })
    .to_return(
      status: 200,
      headers: { content_type: 'text/html' },
      body: load_http_stub(project))
end

def stub_request_on_github_with_404
  stub_request(:get, "https://github.com/stub404/stub404")
    .with(headers: { 'Accept'=>'*/*' })
    .to_return(
      status: 404,
      headers: { content_type: 'text/html' })
end


class String
  def unindent
    gsub(/^\s+\|/, '')
  end
end
